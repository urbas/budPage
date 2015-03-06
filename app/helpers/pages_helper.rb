module PagesHelper

  include Rails.application.routes.url_helpers

  def pages
    unless defined? @pages
      @pages = [
          {name: 'About', url: pages_path(:about)},
          {name: 'Guide', url: pages_path(:guide)},
          {name: 'Licence', url: pages_path(:licence)},
          {name: 'Contact', url: pages_path(:contact)}
      ]
    end
    @pages
  end

  def is_page_active(page)
    current_page_url = Rails.application.routes.url_for(controller: :pages, action: :page, page: params[:page], only_path: true)
    current_page_url.starts_with?(page[:url])
  end

end
