class Ability
  include CanCan::Ability

  def initialize(user)
    user ||=User.new
    if user.role? "admin"
        can :manage, :all?
    else

        can :create, User
        can :edit, User do |u|
          u.id == user.id
        end
        can :read, User
        can :update, User do |u|
          u.id == user.id
        end
        can :destroy, User do |u|
          u.id == user.id
        end

        can :raise_flag, User
        can :lower_flag, User
        can :support_user, User
        can :remove_support, User
        # can :read, RedFlags

        can :create, Post
        can :read, Post
        can :edit, Post do |p|
            p.user_id == user.id
        end
        can :update, Post do |p|
            p.user_id == user.id
        end
        can :destroy, Post do |p|
            p.user_id == user.id
        end
        can :mark_inappropriate, Post
        can :tags, Post do |p|
            p.user_id == user.id
        end

        can :create, Comment
        can :read, Comment
        can :edit, Comment do |c|
            c.user_id == user.id
        end
        can :update, Comment do |c|
            c.user_id == user.id
        end
        can :destroy, Comment do |c|
            (c.user_id == user.id) || (c.post.user_id == user.id)
        end
        can :mark_inappropriate, Comment

        can :create, Friendship
        can :read, Friendship do |f|
          f.proposer_id == user.id || f.proposee_id == user.id
        end
        can :edit, Friendship do |f|
          f.proposer_id == user.id || f.proposee_id == user.id
        end
        can :update, Friendship do |f|
          f.proposer_id == user.id || f.proposee_id == user.id
        end
        can :destroy, Friendship do |f|
          f.proposer_id == user.id || f.proposee_id == user.id
        end
        can :update_sharing_pref, Friendship do |f|
          f.proposer_id == user.id || f.proposee_id == user.id
        end

        # can :read, Friend

    end
  end
end
