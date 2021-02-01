module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # 上記に当てはまらなければfalseを返す
    false
  end
  
  #在社時間の計算を行います（当日）
  def working_times(start, finish_time)
    format("%.2f", (((finish_time - start) / 60) / 60))
  end

  #在社時間の計算を行います（翌日）
  def working_times_for_next(start, finish_time)
    calc_time = start.change(year: start.year, month:start.month, day: start.day - 1)
    format("%.2f", (((finish_time - calc_time) / 60) / 60))
  end

  def showing_overtime_user(user,superior)
    user.attendances.where(receive_superior_id: superior).any? ? true : false
  end
  #勤怠編集の翌日チェック時の処理

  # 時間外時間を計算します(当日)
  def calculation_overtime(finish_time, schedule_end)
    calc_time = schedule_end.change(year: finish_time.year, month: finish_time.month, day: finish_time.day)
    format("%.2f", (((finish_time.time - calc_time.time) / 60) /60))
  end

  #時間外時間を計算します(翌日)
  def calculation_overtime_for_next(finish_time,schedule_end)
    calc_time = schedule_end.change(year: finish_time.year, month: finish_time.month, day: finish_time.day - 1)
    format("%.2f", (((finish_time.time - calc_time.time) / 60) /60))
  end

  def display_before_time(attendance)
    l(attendance.history.log_started_at_to_change_attendance.floor_to(15.minute), format: :hour)
  end
end
