class SparklyAccountsController < SparklyController
  require_login_for :show, :edit, :update, :destroy

  # GET new_model_url
  def new
  end

  # POST model_url
  def create
    model.display_name = model.username if model.display_name.blank?
    if model.save
      login! model
      redirect_back_or_default Auth.default_destination, Auth.account_created_message
    else
      render :action => 'new'
    end
  end

  # GET model_url
  def show
  end

  # GET edit_model_url
  def edit
  end

  # PUT model_url
  def update
    if !model_params[:password].blank? || !model_params[:password_confirmation].blank?
      model.password = model_params[:password]
      model.password_confirmation = model_params[:password_confirmation]
    end
    
    model.attributes = model_params.without(:password, :password_confirmation)
    if model.save
      login!(model)
      redirect_back_or_default user_path, Auth.account_updated_message
    else
      render :action => 'edit'
    end
  end

  # DELETE model_url
  def destroy
    current_user && current_user.destroy
    logout!
    @current_user = nil
    flash[:notice] = Auth.account_deleted_message
    redirect_back_or_default Auth.default_destination
  end

  protected
  def find_user_model
    # password fields are protected attrs, so we need to exclude them then add them explicitly.
    self.model_instance = current_user ||
            returning(model_class.new(model_params.without(:password, :password_confirmation))) { |model|
              model.password = model_params[:password]
              model.password_confirmation = model_params[:password_confirmation]
            }
  end

  # Uncomment if you don't trust the params[:model] set up by Sparkly routing, or if you've
  # disabled them.
  #
  def model_name
    "User"
  end
end
