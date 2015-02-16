require 'redcarpet'

module MainHelper
  include SessionHelper

  def frontmatter
    if logged_in?
      file_to_parse = 'app/assets/markdown/logged_in.md'
    else
      file_to_parse = 'app/assets/markdown/logged_out.md'
    end
    @renderer ||= Redcarpet::Render::HTML.new(render_options = {})
    @markdown ||= Redcarpet::Markdown.new(@renderer, extensions = {})
    @markdown.render(IO.read(file_to_parse)).html_safe
  end
end
