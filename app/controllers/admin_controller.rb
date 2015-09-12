class AdminController < ApplicationController
  before_action :clean_flash, only: [:edit_user, :update_user]
  before_action :set_user, only: [:edit_user, :update_user]

  def index
  end

  def users
    @users = User.all
  end

  def edit_user
  end

  def update_user
    @user.quota_mb = user_params[:use_default_space_quota] == 0 ? nil : user_params[:quota_mb]
    if @user.save
      flash[:notice] = 'User settings successfully updated.'
    else
      flash[:alert] = 'User settings update was not successful.'
    end
    render 'edit_user'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = 'User not found.'
        redirect_to action: 'users'
      end
    end

    # Clearing past flash message.
    def clean_flash
      flash[:notice] = nil
      flash[:alert] = nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:quota_mb, :use_default_space_quota)
    end
end
