class Api::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def show
    user = User.find(params[:id])
    render json: { status: 'SUCCESS', message: 'Loaded the user', data: user }
  end

  private
  def sign_up_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
