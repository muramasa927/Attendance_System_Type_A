class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :attendances_log, :attendances_log_update, :update_approval_to_user, :edit_approval_to_superior]
  before_action :not_access_to_admin, only: [:show, :edit]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy,:edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info, :attendances_employee]
  before_action :set_one_month, only: :show
  before_action :new_login_user, only: :new
  before_action :other_user, only: :show
  
  def index
    @users = User.paginate(page: params[:page],per_page: 10).where(admin: false)
  end
  
  def show
    respond_to do |format|
      format.html do
        @worked_sum = @attendances.where.not(started_at: nil).count
        @apply_attendances = Attendance.where(application_information: 1).where(receive_superior_id: @user.id)
        @change_attendances = Attendance.where(change_attendance_information: 1).where(receive_superior_id_to_change_attendance: @user.id)
        @approvals = Approval.where(superior_id: params[:id]).where(information: 1)
        @approval = @user.approvals.find_by(month: @first_day)
        @superiors = User.where(superior: true).where.not(id: @user.id)
      end
      format.csv do |csv|
        send_data render_to_string, filename: "#{@user.name}の#{l(@first_day, format: :month)}の勤怠情報.csv", type: :csv
      end
    end
  end
  
  def new
    # ユーザーオブジェクトを生成し、インスタンス変数に代入
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if current_user.admin?
      if @user.update_attributes!(basic_info_params)
        flash[:success] = "#{@user.name}のユーザー情報を更新しました"
        redirect_to users_url
      else
        redirect_to users_url
      end
    else
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました"
        redirect_to @user
      else
        render :edit
      end
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました"
    redirect_to users_url
  end

  #csvインポート
  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end
  
  #出勤社員一覧
  def attendances_employee
    @attendances_employee = User.where(attendance_flag: true).paginate(page: params[:page])
  end

  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def edit_time_info
    @users = User.all
  end
  
  def update_time_info
    @users = User.all
    @users.each do | user |
      user.update_attributes(time_info_params)
    end
    flash[:success] = "ユーザーの基本情報を更新しました"
    redirect_to users_url
  end

  def attendances_log
    @attendances = @user.attendances.where(log_flag: true).order(worked_on: "ASC")
  end

  def attendances_log_update
    @attendances = @user.attendances.where(log_flag: true)
    unless params[:search_month].blank?
      str_search_first_day = params[:search_month] + "-1"
      search_first_day = str_search_first_day.to_date
      @search_attendances = @user.attendances.where(worked_on: search_first_day.in_time_zone.all_year).where(worked_on: search_first_day.in_time_zone.all_month).where(log_flag: true)
    end
  end
  # プライベート
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(
                                    :name, :email, :affiliation, :employee_number,
                                    :uid,:basic_work_time, :designated_work_start_time,
                                    :designated_work_end_time, :password, :password_confirmation,
                                  )
    end
    
    def time_info_params
      params.require(:user).permit(:basic_work_time, :work_time)
    end
end
