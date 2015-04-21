module Snippets

  INDENTATION_MATCHER = /^\s*/
  SNIPPET_START_MARKER = 'SNIPPET:'
  SNIPPET_END_MARKER = 'END_SNIPPET:'

  def snippet(path, **options)
    snippet_lines = read_snippet_lines(path, options[:id])
    snippet_lines = indent_lines(snippet_lines, options)
    snippet_lines.join
  end

  private
  def read_snippet_lines(file_path, snippet_id)
    if snippet_id
      File.open(file_path) { |file|
        remove_indentation(extract_snippet_id_lines(snippet_id, file.readlines))
      }
    else
      File.readlines(Rails.root.join(file_path))
    end
  end

  private
  def indent_lines(lines, options)
    line_prefix = options.fetch(:indent_string, ' ') * options.fetch(:indent, 0)
    lines[0, 1] + lines[1..-1].map { |line| line_prefix + line }
  end

  private
  def remove_indentation(lines_in_snippet)
    indentation = smallest_indentation(lines_in_snippet)
    lines_in_snippet.map { |line| line.slice(indentation.length, line.length) }
  end

  private
  def extract_snippet_id_lines(snippet_id, lines)
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