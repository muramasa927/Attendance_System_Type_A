module ApprovalsHelper
	def showing_approval_user(user,superior)
    user.approvals.where(superior_id: superior).any? ? true : false
  end
end
