class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルタ
    
  # ユーザーを取得する
  def set_user
    @user = User.find(params[:id])
  end
  
  # ログイン済みのユーザーか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
  
  def new_login_user
    if logged_in?
      flash[:danger] = "既にログインしています"
      redirect_to root_url
    end
  end
  # 現在ログインしているユーザーか確認
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者権限保有者か判定
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
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
  
  # 1週間表示
  def set_one_week
    @week_first_day = params[:date].nil? ?
                      Date.current.biginning_of_week : params[:date].to_date
    @week_last_day = @week_first_day.end_of_week
    one_week = [*@week_first_day..@week_last_day]
    @attendances = @user.attendances.where(worked_on: @week_first_day..@week_last_day).order(:worked_on)
    
    unless one_week.count == @attendances.count
      ActiveRecord::Base.transaction do
        # 1週間分の勤怠データを生成
        one_week { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @week_first_day..@week_last_day).order(:worked_on)
    end
    
  # トランザクションエラーの分岐
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の更新に失敗しました。再アクセスしてください。"
    redirect_to root_url
  end
  
end
