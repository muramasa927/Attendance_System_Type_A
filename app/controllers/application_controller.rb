class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # ページ出力前に１ヶ月分のデータの存在を確認・セット
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    # 対象の月の日数を代入
    one_month = [*@first_day..@last_day]
    # ユーザーに紐づく１ヶ月分のレコードを検索し取得
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    
    # それぞれの件数（日数）が一致するか評価
    unless one_month.count == @attendances.count
      # トランザクション
      ActiveRecord::Base.transaction do
        # １ヶ月分の勤怠データを生成
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  # トランザクションエラー時の分岐
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の更新に失敗しました。再アクセスしてください。"
    redirect_to root_url
  end
end
