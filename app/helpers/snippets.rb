module Snippets

  INDENTATION_MATCHER = /^\s*/
  SNIPPET_START_MARKER = 'SNIPPET:'
  SNIPPET_END_MARKER = 'END_SNIPPET:'

  def snippet(path, **options)
    snippet_id = options[:id]
    if snippet_id
      File.open(path) { |file|
        remove_indentation(lines_in_snippet(snippet_id, file.readlines)).join
      }
    else
      File.read(Rails.root.join(path))
    end
  end

  private
  def remove_indentation(lines_in_snippet)
    indentation = smallest_indentation(lines_in_snippet)
    lines_in_snippet.map { |line| line.slice(indentation.length, line.length) }
  end

  private
  def lines_in_snippet(snippet_id, lines)
    start_of_snippet = SNIPPET_START_MARKER + ' ' + snippet_id.to_s
    end_of_snippet = SNIPPET_END_MARKER + ' ' + snippet_id.to_s
    lines.take_while { |line| !end_of_snippet.in?(line) }
        .reverse
        .take_while { |line| !start_of_snippet.in?(line) }
        .select { |line| !SNIPPET_START_MARKER.in?(line) && !SNIPPET_END_MARKER.in?(line) }
        .reverse
  end

  private
  def smallest_indentation(lines)
    lines.map { |line| INDENTATION_MATCHER.match(line).to_s }
        .reduce { |a, b| smallest_common_prefix(a, b) }
  end

  private
  def smallest_common_prefix(str1, str2)
    if str1.starts_with?(str2)
      str2
    elsif str2.starts_with?(str1)
      str1
    else
      ''
    end
  end

end