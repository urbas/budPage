module PagesHelper

  Pages = Struct.new(:pages, :paths_to_pages, :page_tree)

  Page = Struct.new(:name, :path, :path_components)

  MarkdownPage = Struct.new(:name, :path, :path_components, :asset_path)

  def render_page_path
    if current_page.is_a?(Page)
      render current_page.path
    elsif current_page.is_a?(MarkdownPage)
      @asset_path = current_page.asset_path
      render 'markdown_page'
    else
      redirect_to pages_path(all_pages[0].path)
    end
  end

  def current_page
    PagesHelper::PAGES.paths_to_pages[params[:page]]
  end

  def all_pages
    PagesHelper::PAGES.pages
  end

  def is_page_active?(parent_page)
    is_in_path_of?(current_page, parent_page)
  end

  def is_in_path_of?(this_page, parent_page)
    this_page.path_components[0..(parent_page.path_components.length-1)] == parent_page.path_components
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
  def self.new_markdown_page(name, path, asset_path)
    MarkdownPage.new(name, path, path_to_components(path), asset_path)
  end

  PAGES = new_pages(
      new_page('About', 'about'),
      new_markdown_page('Docs', 'docs', 'guide.html'),
      new_page('Licence', 'licence'),
      new_page('Contact', 'contact')
  )

end
