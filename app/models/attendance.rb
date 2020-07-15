class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在するとき、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fans_if_invalid
  #出勤日当日以外は出勤・退勤時間の両方が入っていないと無効
  validate :not_today_worked_on_started_at_and_finished_at_precence_invalid
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fans_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  def not_today_worked_on_started_at_and_finished_at_precence_invalid
    unless worked_on == Date.current
      errors.add(:started_at, "と退勤時間両方必要です") if started_at.present? ^ finished_at.present?
    end
  end
  
end
