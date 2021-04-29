class Attendance < ApplicationRecord
  has_one :history, dependent: :destroy
  belongs_to :user

  attr_accessor :remember_token
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在するとき、出勤時間より早い退勤時間は無効
  # なお、翌日にチェックが入っている場合、出勤時間より遅い退勤時間を無効にする
  validate :started_at_than_finished_at_fans_if_invalid
  #出勤日当日以外は出勤・退勤時間の両方が入っていないと無効
  validate :not_today_worked_on_started_at_and_finished_at_precence_invalid
  #残業申請で翌日にチェックが入っている場合、定時開始時間より遅い退勤時間を無効にする
  validate :finish_overtime_than_started_at_if_next_day


  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fans_if_invalid
    if started_at.present? && finished_at.present?
      unless next_day
        errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
      end
    end
  end
  
  def not_today_worked_on_started_at_and_finished_at_precence_invalid
    unless worked_on == Date.current
      errors.add(:started_at, "と退勤時間両方必要です") if started_at.present? ^ finished_at.present?
    end
  end

  def finish_overtime_than_started_at_if_next_day
    if started_at.present? && finish_overtime.present?
      if next_day
        errors.add(:started_at, "より遅い残業時間は無効です") if started_at < finish_overtime
      else
        errors.add(:started_at, "より早い残業時間は無効です") if started_at > finish_overtime
      end
      
    end
  end
  
end
