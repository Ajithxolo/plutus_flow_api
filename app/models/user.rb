class User < ApplicationRecord
  has_many :expenses, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :supabase_id, uniqueness: true, allow_nil: true
end
