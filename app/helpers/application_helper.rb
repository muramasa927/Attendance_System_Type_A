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
end
