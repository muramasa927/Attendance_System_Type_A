module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # 上記に当てはまらなければfalseを返す
    false
  end
  
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60))
  end

  def showing_overtime_user(user,superior)
    # 記述調べる
    if user.attendances.where(receive_superior_id: superior).any?
      true
    else
      false
    end
  end

end
