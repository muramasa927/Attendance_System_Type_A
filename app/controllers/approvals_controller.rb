class ApprovalsController < ApplicationController
	before_action :set_user_for_user_id, only: [:edit]
	before_action :logged_in_user, only: [:update, :update_apply, :edit]

	def update_apply
		@approval = Approval.find(params[:id])
		@user = User.find(@approval.user_id)
		correct_user
    if @approval.update_attributes(apply_params)
			@user.apply = true
			@user.save
      flash[:success] = "１ヶ月の勤怠を所属長に申請しました"
      redirect_to @user
    else
      render :show
    end
  end

  def edit
    @approvals = Approval.where(superior_id: params[:user_id] ).where(apply: true)
		@apply_users = User.where(apply: true)
  end

#１ヶ月の勤怠承認の更新処理
  def update
		@count = 0
		ActiveRecord::Base.transaction do
			approval_params.each do |id, item|
				approval = Approval.find(id)
				@superior = User.find(approval.superior_id)
				user = User.find(approval.apply_id)
				if item[:change] && item[:information] != "1"
					if item[:information] == "0"
						#変更がtrueで申請情報が[なし]の時
						#approvalの情報を前の状態に戻す
						item[:superior_id] = approval.log_superior_id if approval.log_superior_id?
						item[:information] = approval.log_information if approval.log_information?
					end
					#変更がtrueかつ申請情報が[申請中以外]の時
					approval.update_attributes!(item)
					approval.log_information = item[:information]
					approval.change = false
					approval.save
					@count += 1
				end
				if  !(user.approvals.where(apply: true).any?)
					user.apply = false
					user.save
				end
			end
		end
		flash[:success] = "#{@count}件の勤怠変更を更新しました"
		redirect_to user_url(@superior)
	# トランジェクションによるエラーの分岐です
	rescue ActiveRecord::RecordInvalid
		flash[:danger] = TRANSACTION_ERROR_MSG
		redirect_to user_url(@superior)
  end

	private
		def apply_params	
			params.require(:approval).permit(:superior_id, :apply, :information, :month, :apply_id)
		end

		def approval_params
			params.require(:user).permit(approvals:[:change, :information, :approve, :log_superior_id, :log_information, :apply])[:approvals]
		end

end
