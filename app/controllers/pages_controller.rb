class PagesController < ApplicationController

  include PagesHelper

  def home
    redirect_to controller: :pages, action: :page, page: PagesHelper::default_page.absolute_path
  end

  def page
    render_current_page
  end

end