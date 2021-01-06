class Company < ApplicationRecord
	validates :id, uniqueness: true, presence: true
	validates :name, presence: true, length: { maximum: 50 }
end
