module PagesHelper

  Pages = Struct.new(:pages, :paths_to_pages, :page_tree)

  Page = Struct.new(:name, :path, :path_components) do
    def render_to(renderer)
      renderer.render path
    end
  end

  Path = Struct.new(:name, :path, :path_components) do
    def render_to(renderer)
      renderer.redirect_to renderer.pages_path(PagesHelper::default_page.path)
    end
  end

  MarkdownPage = Struct.new(:name, :path, :path_components, :asset_path) do
    def render_to(renderer)
      renderer.render 'markdown_page', locals: {asset_path: asset_path}
    end
  end

  def render_page_path
    if current_page
      current_page.render_to(self)
    else
      redirect_to pages_path(PagesHelper::default_page.path)
    end
  end

  def current_page
    PagesHelper::PAGES.paths_to_pages[params[:page]]
  end

  def self.default_page
    PagesHelper::PAGES.pages[0]
  end

  def default_page
    PagesHelper::default_page
  end

  def self.all_pages
    PagesHelper::PAGES.pages
  end

  def all_pages
    PagesHelper::all_pages
  end

  def is_page_active?(parent_page)
    is_in_path_of?(current_page, parent_page)
  end

  def is_in_path_of?(this_page, parent_page)
    if this_page
      this_page.path_components[0..(parent_page.path_components.length-1)] == parent_page.path_components
    else
      false
    end
  end

  def has_sub_pages?(page)
    all_pages.any? { |other_page| sub_page_of?(other_page, page) }
  end

  def sub_page?(page)
    all_pages.any? { |other_page| sub_page_of?(page, other_page) }
  end

  def sub_pages(page)
    all_pages.select { |other_page| sub_page_of?(other_page, page) }
  end

  private
  def sub_page_of?(page, parent_page)
    is_in_path_of?(page, parent_page) && page != parent_page
  end

  private
  def self.path_to_components(path)
    path.split('/').select { |x| !x.empty? }
  end

  private
  def self.new_pages(*pages)
    Pages.new(pages, pages.map { |page| [page.path, page] }.to_h)
  end

  private
  def self.new_page(name, path)
    Page.new(name, path, path_to_components(path))
  end

  private
  def self.new_path(name, path)
    Path.new(name, path, path_to_components(path))
  end

  private
  def self.new_markdown_page(name, path, asset_path)
    MarkdownPage.new(name, path, path_to_components(path), asset_path)
  end

  PAGES = new_pages(
      new_page('About', 'about'),
      new_path('Docs', 'docs'),
      new_markdown_page('Guide', 'docs/guide', 'guide.html'),
      new_markdown_page('Outline', 'docs/outline', 'outline.html'),
      new_page('Licence', 'licence'),
      new_page('Contact', 'contact')
  )

end
