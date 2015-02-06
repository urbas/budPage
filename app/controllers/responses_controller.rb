class ResponsesController < ActionController::Base

  def index
    @responses = Response.all
  end

end