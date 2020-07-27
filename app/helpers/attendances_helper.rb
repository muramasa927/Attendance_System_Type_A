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
end
