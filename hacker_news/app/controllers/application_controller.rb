class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def hello
    render html: "<h1>It works HackerNews!</h1>".html_safe
  end
end
