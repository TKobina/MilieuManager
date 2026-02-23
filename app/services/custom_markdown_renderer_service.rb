class CustomMarkdownRendererService < Redcarpet::Render::HTML
  # Override the method for a specific Markdown element.
  # For example, to add custom CSS classes to blockquotes:
  # def block_quote(quote)
  #   %(<blockquote class="my-custom-class">#{quote}</blockquote>)
  # end

  # You can also use the preprocess method to perform text substitutions
  # using regex before the main parsing begins (e.g., for @mentions or custom tags):
  def preprocess(text)
    replace_tags(text)
  end

  def replace_tags(text)
    temp = text.gsub!(/\[\[(.*?)\]\]/) { |match| build_link($1) }
    temp.nil? ? text : temp
  end

  def build_link(tag)
    arr = tag.split("|")
    iden = arr[0].split("-")
    eid = iden[1]
    name = arr[1] || iden[0]
    
    entity = @options[:milieu].entities.where(eid: eid)&.first
    return name unless entity.present?

    "[#{name}](#{@options[:request].base_url + "/entities/#{entity.id}?current_milieu=#{@options[:milieu].id}"})"
  end

  # To include features from other modules, like syntax highlighting with Rouge:
  # include Rouge::Plugins::Redcarpet # requires 'rouge/plugins/redcarpet'
  # def block_code(code, language)
  #   ... custom code highlighting logic ...
  # end
end