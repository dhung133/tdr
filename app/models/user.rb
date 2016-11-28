class User < ApplicationRecord
  acts_as_voter
  
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
    :rememberable, :validatable,
    :omniauthable, :omniauth_providers => [:facebook]

  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :requests, dependent: :destroy
  
  has_many :active_relationships, class_name: "Relationship",
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
    foreign_key: "followed_id", dependent: :destroy
  
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates_integrity_of :avatar
  validates_processing_of :avatar

  enum role:{user: 0, admin: 1}

  def is_user?(user)
    self == user
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"
    Review.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def follow other_user
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user 
    following.include?(other_user)
  end

  def review_location? location_id
    reviews.find_by location_id: location_id
  end

  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.remote_avatar_url = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
