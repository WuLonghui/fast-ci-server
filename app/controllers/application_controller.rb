class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  skip_before_filter :verify_authenticity_token 
  
  def success_render(code, data = nil)
    body = {"code" => code, "status" => "sucess"}
    body["data"] = data if data != nil
    render status: code, json: body
  end
  
  def error_render(code, message)
    render status: code, json: {"code" => code, "status" => "error", "message" => message}
  end
end
