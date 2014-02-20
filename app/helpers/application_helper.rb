module ApplicationHelper
  def current_user?
    current_user != nil
  end

  def current_user
    @current_user ||= User.where(id: session[:calendar_user_id]).first
  end

end
