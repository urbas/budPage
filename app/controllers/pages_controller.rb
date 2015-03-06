class PagesController < ApplicationController#

  def home
    redirect_to controller: :pages, action: :page, page: 'about'
  end

  def page
    render params[:page]
  end

end