require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorization_required!

private
  def google_api_client
    @google_client ||= Google::APIClient.new(
      :application_name => 'Ruby Calendar Stats App',
      :application_version => '1.0.0')

    unless current_user?
      client_secrets = Google::APIClient::ClientSecrets.load "#{Rails.root}/config"
      @google_client.authorization = client_secrets.to_authorization
      @google_client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
    else
      @google_client.authorization = current_user.google_authorization
    end

    @google_client
  end

  def current_user?
    current_user != nil
  end

  def current_user
    @current_user ||= User.where(id: session[:calendar_user_id]).first
  end


  def authorization_required!
    redirect_to google_authorization_path unless current_user? or (params[:controller] == 'authorization' or params[:action] == 'welcome')
  end

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
