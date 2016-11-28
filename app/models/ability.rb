class Ability
  include CanCan::Ability

  def initialize user, namespace
    user ||= User.new # guest user (not logged in)
    if namespace == "admin"
      if user.admin?
        can :manage, :all
      else
        cannot :manage, :all
      end
    else
      if user.admin?
        cannot :manage, :all
        can :read, :all
      else
        can [:create, :destroy], Request, user_id: user.id
        can :read, :all
        can :manage, Review, user_id: user.id
        can :manage, Comment, user_id: user.id
        can :read, Category, user_id: user.id
        can [:following, :followers], User
      end
    end
  end
end
