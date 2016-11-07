class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, presence: true
  validates :review_id, presence: true
  validates :content, length: {maximum: 1000}, presence: true 
  default_scope -> { order(created_at: :desc) }
end
