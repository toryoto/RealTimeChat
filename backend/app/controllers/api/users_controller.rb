module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update_email_visibility]

    def show
      render json: @user
    end

    def update_email_visibility
      new_visibility = !@user.is_email_public
  
      if @user.update(is_email_public: new_visibility)
        render json: @user, status: :ok
      else
        # バリデーションエラーメッセージのログ
        Rails.logger.info(@user.errors.full_messages)
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end

    def user_params
      params.require(:user).permit(:is_email_public)
    end
  end
end