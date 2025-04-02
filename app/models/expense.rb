class Expense < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :description, length: { maximum: 500 }, allow_blank: true
end
