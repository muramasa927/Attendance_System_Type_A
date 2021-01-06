class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルタ


    
  # ユーザーを取得する
  def set_user
    @user = User.find(params[:id])
  end

  #userがadminの時、indexページへリダイレクトする
  def not_access_to_admin
    redirect_to users_url if @user.admin? 
  end

  # ログイン済みのユーザーか確認
  def logged_in_user
    unless logged_in?
      if !@user.superior?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
  end
  
  def new_login_user
    if logged_in?
      flash[:danger] = "既にログインしています"
      redirect_to root_url
    end
  end
  # 現在ログインしているユーザーもしくは管理者か確認
  def correct_user
    redirect_to(root_url) unless current_user.admin? || current_user?(@user)
  end
  
  # 管理者権限保有者か判定
  def admin_user
    unless current_user.admin?
      flash[:danger] = "管理者ではありません"
      redirect_to root_url
    end
  end
  # 他のユーザーへのアクセスを不可
  def other_user
    if User.find(params[:id]) == current_user || current_user.admin? || current_user.superior?
    else
      flash[:danger] = "他ユーザーへのアクセスは制限されています"
      redirect_to root_url
    end
  end

  #拠点情報を取得する
  def set_company
    @company = Company.find(params[:id])
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
        # one_month.each { |day| @user.attendances.create!(worked_on: day) }
        one_month.each do |day|
          @user.attendances.create!(worked_on: day)
        end
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  # トランザクションエラー時の分岐
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の更新に失敗しました。再アクセスしてください。"
    redirect_to root_url
  end

end
