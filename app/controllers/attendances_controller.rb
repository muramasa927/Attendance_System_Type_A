class AttendancesController < ApplicationController
	
	before_action :set_user, only: [:edit_one_month]
	before_action :logged_in_user, only: [:update, :edit_one_month]
	before_action :set_one_month, only: [:edit_one_month]
	
	UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
	TRANSACTION_ERROR_MSG = "無効な入力データがあった為、更新をキャンセルしました"
	#出勤・退勤登録
	def update
		@user = User.find(params[:user_id])
		@attendance = Attendance.find(params[:id])
		# 出勤時間が未登録か確認
		if @attendance.started_at.nil?
			if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
				@attendance.history.update_attributes(log_before_started_at: Time.current.change(sec: 0), log_started_at_to_change_attendance:  Time.current.change(sec: 0))
				@user.attendance_flag = true
				@user.save
				flash[:info] = "おはようございます!"
			else
				flash[:danger] = UPDATE_ERROR_MSG
			end
		elsif @attendance.finished_at.nil?
			if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
				@attendance.history.update_attributes(log_before_finished_at: Time.current.change(sec: 0), log_finished_at_to_change_attendance:  Time.current.change(sec: 0))
				@user.attendance_flag = false
				@user.save
				flash[:info] = "お疲れ様でした"
			end
		end
		redirect_to @user
	end
	
	def edit_one_month
		@superiors = User.where(superior: true).where.not(id: @user.id)
	end
	
	def update_one_month
		# トランザクション開始
		ActiveRecord::Base.transaction do
			@count = 0
			attendances_params.each do |id, item|
				attendance = Attendance.find(id)
			unless item[:receive_superior_id_to_change_attendance].blank?
					attendance.update_attributes!(item)
					user = User.find(item[:apply_user_id_to_change_attendance])
					user.applying_change_attendance = true
					@count += 1
					user.save
				end
			end
		end
		flash[:success] ="#{@count}件の勤怠情報を申請しました。"
		redirect_to user_url(date: params[:date])
	# トランジェクションによるエラーの分岐です
	rescue ActiveRecord::RecordInvalid
		flash[:danger] = TRANSACTION_ERROR_MSG
		redirect_to attendances_edit_one_month_user_url(date: params[:date])
	end

	#勤怠変更の承認用action(モーダル)
	def edit_change_attendance_confirmation
		@user = User.find(params[:user_id])
		@change_attendance_users = User.where(applying_change_attendance: true)
		@applying_change_attendances = Attendance.where(change_attendance_information: 1).where(receive_superior_id_to_change_attendance: @user.id)
	end
	#勤怠変更の承認用update_action
	def update_change_attendance_confirmation	
		@count = 0
		ActiveRecord::Base.transaction do
			change_attendance_confirmation_params.each do |id, item|
				@attendance = Attendance.find(id)
				@superior = User.find(@attendance.receive_superior_id_to_change_attendance)
				user = User.find(@attendance.user_id)
				if item[:change_information_to_attendance] && item[:change_attendance_information] != "1"
					if item[:change_attendance_information] == "0"
						return_history_to_change_attendance_confirmation
						item[:change_attendance_information] = @attendance.history.log_change_attendance_information
					end
					add_history_to_change_attendance_confirmation
					@attendance.receive_superior_id_to_change_attendance = nil
					#変更がtrueかつ申請情報が[申請中以外]の時
					@attendance.update_attributes!(item)
					@attendance.log_flag = true
					@attendance.change_information_to_attendance = false
					@count += 1
					@attendance.save
				end
				if  !(user.attendances.where(change_attendance_information: true).any?)
					user.applying_change_attendance = false
					user.save
				end
			end
		end
		flash[:success] = "#{@count}件の勤怠変更を更新しました"
		redirect_to user_url(@superior)
	# トランジェクションによるエラーの分岐です
	rescue ActiveRecord::RecordInvalid
		flash[:danger] = TRANSACTION_ERROR_MSG
		redirect_to user_url(@superior)
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
		ActiveRecord::Base.transaction do
			apply_overtime_user = User.find(params[:user_id])
			@attendance = Attendance.find(params[:id])
			apply_overtime_user.applying_overtime = true
			@attendance.update_attributes(overtime_application_params)
			if params[:user][:attendance][:next_day]
				@attendance.finish_overtime = @attendance.finish_overtime.change(day: params[:user][:attendance]["finish_overtime(3i)"].to_i + 1) 
			end
			@attendance.save
			apply_overtime_user.update_attributes(apply_overtime_user_params)
			flash[:success] = "ユーザーの基本情報を更新しました"
			redirect_to(current_user)
		end
	rescue ActiveRecord::RecordInvalid
		flash[:danger] = TRANSACTION_ERROR_MSG
		redirect_to user_url(@superior) 
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
				@attendance = Attendance.find(id)
				@superior = User.find(@attendance.receive_superior_id)
				user = User.find(@attendance.user_id)
				if item[:change_information] && item[:application_information] != "1"
					if item[:application_information] == "0"
						return_history_to_overtime_confirmation
						item[:application_information] = @attendance.history.log_application_information
					end
					#変更がtrueかつ申請情報が[申請中以外]の時
					@attendance.update_attributes!(item)  
					add_history_to_overtime_confirmation
				end
				if  !(user.attendances.where(application_information: true).any?)
					user.applying_overtime = false
					user.update_attributes!(apply_overtime_user_params)
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
		params.require(:user).permit(
			attendances:[
				:started_at, :finished_at, :note, :next_day,
				:receive_superior_id_to_change_attendance,
				:apply_user_id_to_change_attendance,
				:change_attendance_information
			]
		)[:attendances]
	end

	def overtime_application_params
		params.require(:user).permit(
			attendance: [
				:finish_overtime, :next_day, :business_processing_content, :receive_superior_id,
				:apply_user_id, :application_information, :change_information
			]
		)[:attendance]
	end

	def apply_overtime_user_params
		params.require(:user).permit(:applying_overtime)
	end
	
	def overtime_confirmation_params
		params.require(:user).permit(:applying_overtime, applying_attendances:[:change_information,:application_information])[:applying_attendances]
	end

	def attendance_history_params
		params.require(:history).permit( 
			:log_finish_overtime, :log_next_day, :log_business_processing_content, 
			:log_receive_superior_id, :log_apply_user_id
		)
	end

	def change_attendance_confirmation_params
		params.require(:user).permit(
			applying_change_attendances:[:change_attendance_information, :change_information_to_attendance]
		)[:applying_change_attendances]
	end

	def admin_or_correct_user
		@user = User.find(params[:user_id]) if @user.blank?
		unless current_user?(@user) || current_user.admin?
			flash[:danger] = "権限がありません"
			redirect_to(root_url)
		end
	end

	#残業申請履歴を追加する
	def add_history_to_overtime_confirmation
		@attendance.history.log_finish_overtime = @attendance.finish_overtime
		@attendance.history.log_application_information = @attendance.application_information
		@attendance.history.log_next_day = @attendance.next_day
		@attendance.history.log_business_processing_content = @attendance.business_processing_content
		@attendance.history.log_receive_superior_id = @attendance.receive_superior_id
		@attendance.history.log_apply_user_id = @attendance.apply_user_id
		@attendance.history.save
	end

	def return_history_to_overtime_confirmation
		@attendance.finish_overtime = @attendance.history.log_finish_overtime
		@attendance.application_information = @attendance.history.log_application_information
		@attendance.next_day = @attendance.history.log_next_day
		@attendance.business_processing_content = @attendance.history.log_business_processing_content
		@attendance.receive_superior_id = @attendance.history.log_receive_superior_id
		@attendance.apply_user_id = @attendance.history.log_apply_user_id
		@attendance.save
	end

	#勤怠変更履歴を追加する
	def add_history_to_change_attendance_confirmation
		@attendance.history.log_started_at_to_change_attendance = @attendance.started_at
		@attendance.history.log_finished_at_to_change_attendance = @attendance.finished_at
		@attendance.history.log_receive_superior_id_to_change_attendance = @attendance.receive_superior_id_to_change_attendance
		@attendance.history.log_next_day = @attendance.next_day
		@attendance.history.log_change_attendance_information = @attendance.change_attendance_information
		@attendance.history.log_note = @attendance.note
		@attendance.history.log_after_started_at = @attendance.started_at
		@attendance.history.log_after_finished_at = @attendance.finished_at
		@attendance.history.log_date_of_apploval = Date.current
		@attendance.history.log_instruction_superior_id = @superior.id
		@attendance.history.save
	end

	#勤怠変更履歴を前の値に戻す
	#１ヶ月の勤怠変更でなしを選択したときに実行
	def return_history_to_change_attendance_confirmation
		@attendance.started_at = @attendance.history.log_started_at_to_change_attendance
		@attendance.finished_at = @attendance.history.log_finished_at_to_change_attendance
		@attendance.receive_superior_id_to_change_attendance = @attendance.history.log_receive_superior_id_to_change_attendance
		@attendance.next_day = @attendance.history.log_next_day
		@attendance.change_attendance_information = @attendance.history.log_change_attendance_information
		@attendance.note = @attendance.history.log_note
		@attendance.save
	end

end
