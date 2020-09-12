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
  
  def edit_overtime_application
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @superiors = User.where(superior: true)
  end

  def update_overtime_application
    @attendance = Attendance.find(params[:id])
    @attendance.update_attributes(overtime_application_params)
    flash[:success] = "ユーザーの基本情報を更新しました"
    redirect_to(current_user)
  end

  private
  
  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
  end

  def overtime_application_params
    params.require(:attendance).permit(:finish_overtime, :next_day, :business_processing_content, :receive_superior_id, :apply_user_id, :application_information)
  end
  
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "権限がありません"
      redirect_to(root_url)
    end
  end
  
end
