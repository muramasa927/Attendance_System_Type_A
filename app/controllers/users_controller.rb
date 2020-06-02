class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])  
  end
  
  def new
    # ユーザーオブジェクトを生成し、インスタンス変数に代入
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました'
      redirect_to @user
    else
      render :new
    end
  end
  
  # プライベート
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
