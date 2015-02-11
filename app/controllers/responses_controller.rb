class ResponsesController < ActionController::Base

  def index
    @responses = Response.all
  end

  def show
    @response = Response.find_by_id(params[:id])
  end

  def family
    @response = Response.includes(:responses, :parent_response).find_by_id(params[:response_id])
  end

end