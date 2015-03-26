class PagesController < ApplicationController

  include PagesHelper

  def home
    redirect_to controller: :pages, action: :page, page: 'about'
  end

  def page
    render_page_path
  end

end