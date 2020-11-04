module UsersHelper
  
  # 勤怠基本情報を指定のフォーマットで返します
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  
  # 表示する上司の名前を返す
  def applying_superior(day)
    @superiors.find(day.receive_superior_id).name
  end

  # 終了予定時間の表示を返す
  def display_finish_time(day)
    if day.finish_overtime.blank?
      @user.scheduled_end_time
    else
       day.application_information == 2 ? day.finish_overtime : @user.scheduled_end_time
    end
  end

  # 申請状況の表示を返す
  def display_application_information(day)
    case day.application_information
    when 0
      str = ""
    when 1
      str = applying_superior(day) + "へ申請中です"
    when 2
      str = applying_superior(day) + "が承認しました"
    when 3
      str = applying_superior(day) + "が否認しました"
    end
  end
end
