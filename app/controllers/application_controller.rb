class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from Exception, with: :handle_error

  private
  # Authenticate using the username and auth_id
  def authenticate
    @current_user = Account.authenticate_user(request.authorization)
    SmsConnect.present_user = @current_user
  end

  def handle_error (exception)
    http_code, error =
    if (exception.message =~ /invalid_credentials/)
      [403, '']
    else
      [500, 'unknown failure']
    end
    render_json(http_code, error)
  end

  # render json out
  def render_json(http_code, error = '', message = '')
    render json: {message: message, error: error}, status: http_code
  end
end
