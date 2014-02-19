class AuthorizationController < ApplicationController
  def google_authorization
    redirect_to user_credentials.authorization_uri.to_s, status: 303
  end

  def google_authorization_callback
    user_credentials.code = params[:code] if params[:code]
    user_credentials.fetch_access_token!

    user = User.where(client_id: user_credentials.client_id).first || User.new
    user.update_credentials user_credentials

    session[:calendar_user_id] = user.id

    redirect_to stats_path
  end

private
  def user_credentials
    @authorization ||= (
      auth = google_api_client.authorization.dup
      auth.redirect_uri = google_authorization_callback_url
      if current_user?
        auth.update_token!(current_user.attributes)
      end
      auth
    )
  end
end
