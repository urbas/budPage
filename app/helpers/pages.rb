module Pages
  class Page
    def initialize(name, path, *sub_pages)
      @name = name
      @path = path
      @sub_pages = sub_pages
      @parent_page = nil
      sub_pages.each { |sub_page| sub_page.parent_page = self }
    end

    def name
      @name
    end

    def path
      @path
    end

    def sub_pages
      @sub_pages
    end

    def parent_page
      @parent_page
    end

    def find_by_path(absolute_path)
      path_to_sub_page[absolute_path]
    end

    def path_to_sub_page
      if @path_to_sub_page.nil?
        direct_path_to_pages = sub_pages.map {|page| [page.absolute_path, page]}.to_h
        nested_path_to_pages = sub_pages.map {|page| page.path_to_sub_page}
        @path_to_sub_page = ([direct_path_to_pages] + nested_path_to_pages)
                                .reduce({}) {|aggregate, path_to_sub_page| aggregate.merge(path_to_sub_page)}
      end
      @path_to_sub_page
    end

    def parent_page=(new_parent)
      if !new_parent
        raise Exception.new("Cannot set the parent to nil.")
      elsif parent_page.nil?
        @parent_page = new_parent
      else
        raise Exception.new("Cannot set a parent. The parent has already been set.")
      end
    end

    def absolute_path
      if parent_page.nil? || parent_page.is_root?
        path
      else
        parent_page.absolute_path + '/' + path
      end
    end

    def is_root?
      parent_page.nil?
    end

    def has_sub_pages?
      !@sub_pages.empty?
    end

    def is_in?(path_components)
      path_components[0..(self.path_components.length-1)] == self.path_components
    end

    def path_components
      if @path_components.nil?
        @path_components = (parent_page.nil? || parent_page.is_root?) ? [path] : parent_page.path_components + [path]
      end
      @path_components
    end

    def render_to(renderer)
      renderer.render absolute_path
    end
  end

  class RootPage < Page
    def initialize(*sub_pages)
      super('root', '', *sub_pages)
    end
  end

  class MarkdownPage < Page
    def initialize(name, path, markdown_asset)
      super(name, path)
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

  def self.path_to_components(path)
    path.split('/').select { |x| !x.empty? }
  end
end

