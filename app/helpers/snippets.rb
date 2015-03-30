module Snippets

  def snippet(path)
    File.read(Rails.root.join(path))
  end

end