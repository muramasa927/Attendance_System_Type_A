class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:edit_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: [:edit_one_month]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  TRANSACTION_ERROR_MSG = "無効な入力データがあった為、更新をキャンセルしました"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録か確認
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます!"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした"
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    # トランザクション開始
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "１ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  # トランジェクションによるエラーの分岐です
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = TRANSACTION_ERROR_MSG
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  #残業の申請
  #一般ユーザー→上長
  def edit_overtime_application
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @superiors = User.where(superior: true).where.not(id: @user.id)
  end

  #残業の申請
  #更新処理
  def update_overtime_application
    apply_overtime_user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    apply_overtime_user.applying_overtime = true
    @attendance.update_attributes(overtime_application_params)
    if params[:user][:attendance][:next_day] = true 
      @attendance.finish_overtime = @attendance.finish_overtime.change(day: params[:user][:attendance]["finish_overtime(3i)"].to_i + 1) 
    end
    @attendance.save
    apply_overtime_user.update_attributes(apply_overtime_user_params)
    flash[:success] = "ユーザーの基本情報を更新しました"
    redirect_to(current_user)
  end

  #残業申請の承認
  #上長→一般ユーザー
  def edit_overtime_confirmation
    @user = User.find(params[:user_id])
    @overtime_users = User.where(applying_overtime: true)
    @applying_attendances = Attendance.where(application_information: 1).where(receive_superior_id: @user.id)
  end

  #残業申請の承認
  #更新処理
  def update_overtime_confirmation
    ActiveRecord::Base.transaction do
      overtime_confirmation_params.each do |id, item|
        attendance = Attendance.find(id)
        @superior = User.find(attendance.receive_superior_id)
        if item[:change_information]
          user = User.find(attendance.user_id)
          user.applying_overtime = false
          user.update_attributes!(apply_overtime_user_params)
          attendance.update_attributes!(item)        
        else
        end
      end
    end
    flash[:success] = "残業申請を更新しました"
    redirect_to user_url(@superior)
  # トランジェクションによるエラーの分岐です
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = TRANSACTION_ERROR_MSG
    redirect_to user_url(@superior)
  end

  private
  
  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
  end

  def overtime_application_params
    params.require(:user).permit(attendance: [:finish_overtime, :next_day, :business_processing_content, :receive_superior_id, :apply_user_id, :application_information, :change_information])[:attendance]
  end

  def apply_overtime_user_params
    params.require(:user).permit(:applying_overtime)
  end
  
  def overtime_confirmation_params
    params.require(:user).permit(:applying_overtime, applying_attendances:[:change_information,:application_information])[:applying_attendances]
  end

  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "権限がありません"
      redirect_to(root_url)
    end
  end

end
