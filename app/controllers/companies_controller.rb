class CompaniesController < ApplicationController
  before_action :set_company, only: [:update, :destroy]
  before_action :admin_user, only: [:index, :create, :update, :dastroy]
  def index
    @companies = Company.all
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      flash[:success] = '拠点の新規作成に成功しました'
      redirect_to companies_url
    else
      flash[:danger] = '拠点の新規作成に失敗しました'
      redirect_to companies_url
    end
  end

  def update
    if @company.update_attributes(company_params)
      flash[:success] = "#{@company.name}の拠点情報を更新しました"
      redirect_to companies_url
    else
      flash[:danger] = "拠点情報の更新に失敗しました"
      redirect_to companies_url
    end
  end

  def destroy
    @company.destroy
    flash[:success] = "#{@company.name}のデータを削除しました"
    redirect_to companies_url
  end

  def company_params
    params.require(:company).permit(:id, :name, :attendance_flag)
  end

end
