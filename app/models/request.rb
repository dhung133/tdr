class Request < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: {maximum: 400}

  enum status: [:waitting, :denied, :accepted]

  scope :accepted, ->{where status: :accepted}
end
