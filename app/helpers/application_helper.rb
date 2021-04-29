module ApplicationHelper
  # ページごとにタイトルを表示
  def full_title(page_name = "")
    base_title = "AttendanceApp"
    if page_name.empty?
      base_title
    else
      format('%s | %s', page_name, base_title)
    end
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
end
