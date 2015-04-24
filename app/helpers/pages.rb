module Pages
  class Page
    def initialize(name, *sub_pages, **options)
      @name = name
      @sub_pages = Rails.env.production? ? sub_pages.select { |sub_page| !sub_page.is_draft? } : sub_pages
      @parent_page = nil
      @is_draft = options.fetch(:is_draft, false)
      sub_pages.each { |sub_page| sub_page.parent_page = self }
    end

    def name
      @name
    end

    def sub_pages
      @sub_pages
    end

    def parent_page
      @parent_page
    end

    def is_draft?
      @is_draft
    end

    def path_components
      if @path_components.nil?
        @path_components = parent_page.nil? ? [name] : parent_page.path_components + [name]
      end
      @path_components
    end

    def absolute_path
      if @absolute_path.nil?
        @absolute_path = path_components.join('/')
      end
      @absolute_path
    end

    def find_by_path(absolute_path)
      path_to_sub_page[absolute_path]
    end

    def has_sub_pages?
      !@sub_pages.empty?
    end

    def is_in_path_of?(page)
      page == self || !page.parent_page.nil? && is_in_path_of?(page.parent_page)
    end

    def render_to(renderer)
      renderer.render absolute_path
    end

    protected
    def parent_page=(new_parent)
      if !new_parent
        raise Exception.new('Cannot set the parent to nil.')
      elsif parent_page.nil?
        @parent_page = new_parent
      else
        raise Exception.new('Cannot set a parent. The parent has already been set.')
      end
    end

    protected
    def path_to_sub_page
      if @path_to_sub_page.nil?
        @path_to_sub_page = sub_pages.map { |page| page.path_to_sub_page }
                                .push(sub_pages.map { |page| [page.absolute_path, page] }.to_h)
                                .reduce({}) { |aggregate, path_to_sub_page| aggregate.merge(path_to_sub_page) }
      end
      @path_to_sub_page
    end
  end

  class RootPage < Page
    def initialize(*sub_pages)
      super('root', *sub_pages)
    end

    def path_components
      []
    end
  end

  class MarkdownPage < Page
    def initialize(name, markdown_asset, **options)
      super(name, *[], **options)
      @markdown_asset = markdown_asset
    end

    def render_to(renderer)
      renderer.render 'markdown_page', locals: {asset_path: @markdown_asset}
    end
  end

  class ContainerPage < Page
    def render_to(renderer)
      sub_pages[0].render_to(renderer)
    end
  end
end

