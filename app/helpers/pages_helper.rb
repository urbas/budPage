module PagesHelper

  include Pages

  def render_current_page
    if current_page
      @page_title = current_page.name
      current_page.render_to(self)
    else
      redirect_to pages_path(PagesHelper::default_page.absolute_path)
    end
  end

  def current_page
    PagesHelper::PAGES.find_by_path(params[:page])
  end

  def self.default_page
    PagesHelper::PAGES.sub_pages[0]
  end

  def is_page_active?(page)
    page.is_in_path_of?(current_page)
  end

  PAGES = RootPage.new(
      Page.new('About'),
      MarkdownPage.new('Hello', 'blog/hello.html'),
      ContainerPage.new(
          'Docs',
          MarkdownPage.new('Guide', 'guide.html'),
          MarkdownPage.new('Outline', 'outline.html'),
          MarkdownPage.new('Roadmap', 'roadmap.html')
      ),
      MarkdownPage.new('Licence', 'licence.html'),
      Page.new('Contact')
  )
end
