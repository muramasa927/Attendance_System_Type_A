module UsersHelper
  
  # 勤怠基本情報を指定のフォーマットで返します
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  
  # 表示する上司の名前を返す
  def applying_superior(day)
    if day.receive_superior_id.present?
      @superiors.find(day.receive_superior_id).name
    elsif day.history.log_receive_superior_id.present?
      @superiors.find(day.history.log_receive_superior_id).name
    end
  end
  # 勤怠変更で表示する上司の名前を返す
  def change_attendance_superior(day)
    if day.receive_superior_id_to_change_attendance.present?
      @superiors.find(day.receive_superior_id_to_change_attendance).name
    elsif day.history.log_receive_superior_id_to_change_attendance.present?
      @superiors.find(day.history.log_receive_superior_id_to_change_attendance).name
    end
  end

  #勤怠ログで表示する上司の名前を返す
  def attendances_log_superior(attendance)
    User.find(attendance.history.log_instruction_superior_id).name
  end

  # 終了予定時間の表示を返す
  def display_finish_time(day)
    if day.finish_overtime.blank?
      @user.designated_work_end_time
    else
      day.application_information == 2 ? day.finish_overtime : @user.designated_work_end_time
    end
  end

  # 残業の申請状況の表示を返す
  def display_application_information(day)
    case day.application_information
    when 0
      str = ""
    when 1
      str = applying_superior(day) + "へ残業申請中です"
    when 2
      str = applying_superior(day) + "が残業を承認しました"
    when 3
      str = applying_superior(day) + "が残業を否認しました"
    end
  end

  # 勤怠変更の申請状況の表示を返す
  def display_change_attendance_information(day)
    case day.change_attendance_information
    when 0
      str = ""
    when 1
      str = change_attendance_superior(day) + "へ勤怠変更申請中です"
    when 2
      str = change_attendance_superior(day) + "が勤怠変更を承認しました"
    when 3
      str = change_attendance_superior(day) + "が勤怠変更を否認しました"
    end
  end

  def attendance_confirm?(user)
    user == current_user 
  end

  def reply_superior(approval)
    case approval.information
    when nil
      str = "所属長承認未"
    when 1
      str =  "所属長へ１ヶ月承認申請中です"
    when 2
      str = "所属長承認済"
    when 3
      str = "所属長が１ヶ月承認を否認しました"
    end 
	end
end



