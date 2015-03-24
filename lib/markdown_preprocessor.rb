require 'rdiscount'

class MarkdownPreprocessor < Sprockets::Processor
  def evaluate(context, locals)
    RDiscount.new(begin;data;end).to_html
  end
end