class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy,:edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :new_login_user, only: :new
  before_action :other_user, only: :show
  
  def index
    @users = User.all.paginate(page: params[:page]).search(params[:search])
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @apply_attendances = Attendance.where(application_information: 1).where(receive_superior_id: @user.id)
    @superiors = User.where(superior: true)

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
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render :edit
    end
    
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました"
    redirect_to users_url
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
  
  # プライベート
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department,:basic_time, :work_time)
    end
    
    def time_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
end
