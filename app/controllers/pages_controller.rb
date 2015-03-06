class PagesController < ApplicationController

  def page
    render params[:page]
  end

end