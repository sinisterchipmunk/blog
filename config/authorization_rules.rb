authorization do
  role :admin do
    has_permission_on [:posts, :comments, :categories, :tags, :users, :blogs, :pingbacks],
                      :to => [:index, :show, :new, :create, :edit, :update, :destroy, :delete_pingback]
  end

  role :guest do
    has_permission_on [:posts, :categories, :tags, :comments], :to => [:index, :show]
    # We already validate that the user is logged in. I don't really care who leaves a message, as long
    # as they have an account.
    has_permission_on :comments, :to => [:edit, :update, :new, :create]
  end

  role :moderator do
    includes :guest
    has_permission_on :comments, :to => [:edit, :update]
  end

  role :author do
    includes :guest
    has_permission_on [:posts, :categories, :tags], :to => [:new, :create]
    has_permission_on [:posts, :categories, :tags], :to => [:edit, :update] do
      if_attribute :user => is { current_user }
    end
    has_permission_on [:pingbacks], :to => [:destroy, :delete_pingback] do
      if_attribute :user => is { current_user }
    end
  end
end
