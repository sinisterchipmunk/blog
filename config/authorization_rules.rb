authorization do
  role :admin do
    has_permission_on [:posts, :comments, :categories, :tags, :users, :blogs],
                      :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  role :guest do
    has_permission_on [:posts, :categories, :tags, :comments], :to => [:index, :show]
    #has_permission_on :comments, :to => [:new, :create]
    has_permission_on :comments, :to => [:edit, :update, :new, :create] do
      if_attribute :user => is { user }
    end
  end

  role :moderator do
    includes :guest
    has_permission_on :comments, :to => [:edit, :update]
  end

  role :author do
    includes :guest
    has_permission_on [:posts, :categories, :tags], :to => [:new, :create]
    has_permission_on [:posts, :categories, :tags], :to => [:edit, :update] do
      if_attribute :user => is { user }
    end
  end
end
