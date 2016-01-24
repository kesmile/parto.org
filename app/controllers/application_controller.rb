class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  def get_token
    o = [('a'..'z'), ('1'..'9')].map { |i| i.to_a }.flatten
    @string = (1...6).map { o[rand(o.length)] }.join @string
    return @string;
  end
end
