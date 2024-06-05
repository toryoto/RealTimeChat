module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show]

    def show
      render json: @user
    end

    def update_email_visibility
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:is_email_public)
    end
  end
end