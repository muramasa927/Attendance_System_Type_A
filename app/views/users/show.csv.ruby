require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 出勤時間  退勤時間)
  csv << column_names
  @attendances.each do |attendance|
    if attendance.change_attendance_information.in?([1,3])
      at_start = ""
      at_finish = ""
    else
      at_start = attendance.started_at.nil? ? attendance.started_at : l(attendance.started_at, format: :time) 
      at_finish = attendance.finished_at.nil? ? attendance.finished_at : l(attendance.finished_at, format: :time)
    end
    column_values = [
      attendance.worked_on,
      at_start,
      at_finish
    ]
    csv << column_values
    
  end
end