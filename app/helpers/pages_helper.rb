module PagesHelper

  include Pages

  def render_current_page
    if current_page
      current_page.render_to(self)
    else
      redirect_to pages_path(PagesHelper::default_page.path)
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
      ContainerPage.new('Blog', MarkdownPage.new('Hello', 'blog/hello.html'), is_draft: true),
      ContainerPage.new('Docs', MarkdownPage.new('Guide', 'guide.html'), MarkdownPage.new('Outline', 'outline.html')),
      Page.new('Licence'),
      Page.new('Contact')
  )
end
