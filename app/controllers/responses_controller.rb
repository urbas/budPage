class ResponsesController < ActionController::Base

  def index
    @responses = Response.all
  end

  def show
    @response = Response.find_by_id(params[:id])
  end

end