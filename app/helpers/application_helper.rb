require "redcarpet"

module ApplicationHelper
  def markdown(text, milieu, request)
    options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow', target: "_self" },
        space_after_headers: true,
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        milieu: milieu,
        request: request
      }
      extensions = {
        autolink:           true,
        superscript:        false,
        disable_indented_code_blocks: true,
        footnotes: true, # Enables footnote support
    }

    #renderer = ::Redcarpet::Render::HTML.new(options)
    renderer = CustomMarkdownRendererService.new(options)
      # Optional: pass render options here (e.g., footnotes: true)
    markdown = ::Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
end