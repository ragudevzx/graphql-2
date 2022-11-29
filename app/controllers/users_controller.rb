class UsersController < ApplicationController
  wrap_parameters :user, include: [:name, :email, :password, :user_type, :avatar, :usertype]
  skip_before_action :require_login, only: [:index, :create]
  # GET /users
  def index
    @users = User.all
    render json: @users
  end
  # GET /users/1
  def show
    render json: @user
  end
  # POST /users
 def create
    user = User.create(user_params)
    if user.valid?
      pages_to_make = PagesController.new
      pages_to_make.make_initial_pages_for(user)
      payload = {user_id: user.id}
      token = encode_token(payload)
      render json: {user: user, jwt: token}
    else
      render json: {errors: user.errors.full_messages}, status: :not_acceptable
    end
  end

  def edit 

    @user = User.find_by(id: params[:id])
    @user.username = params[:username]
    @user.name = params[:name]
    @user.email = params[:email]
    @user.avatar = params[:avatar]
    @user.save

  end
  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :user_type, :avatar, :usertype)
    end
end
