module PagesHelper

  Page = Struct.new(:name, :route_name) do

    include Rails.application.routes.url_helpers

    def url
      pages_path(route_name)
    end

    def member?(route_name)
      current_page_url = Rails.application.routes.url_for(controller: :pages, action: :page, page: route_name, only_path: true)
      current_page_url.starts_with?(url)
    end

  end

  def pages
    unless defined? @pages
      @pages = [
          Page.new('About', :about),
          Page.new('Guide', :guide),
          Page.new('Licence', :licence),
          Page.new('Contact', :contact)
      ]
    end
    @pages
  end

end
