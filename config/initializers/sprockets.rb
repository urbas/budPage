require 'markdown_preprocessor'

Rails.application.assets.register_engine('.md', MarkdownPreprocessor)