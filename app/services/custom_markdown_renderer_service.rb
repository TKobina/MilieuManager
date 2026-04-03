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
    
    object, link = nil, nil

    case iden[0]
    when "lexeme"
      #[[lexeme-eid-language_name|lexeme]]
      language = @options[:milieu].languages.where(name: iden[2]).first || @options[:milieu].languages.first
      object = language.lexemes.where(eid: eid)&.first
      return name if object.nil?
      link = "[#{object.word }](#{@options[:request].base_url + "/lexemes/#{object.id}?current_milieu=#{@options[:milieu].id}&language_id=#{language.id}"})"
    when "event"
      #[[event-id|name]]
      object = @options[:milieu].events.where(id: eid)&.first
      return name if object.nil?
      link = "[#{name}](#{@options[:request].base_url + "/events/#{object.id}?current_milieu=#{@options[:milieu].id}"})"
    else
      object = @options[:milieu].entities.where(eid: eid)&.first
      return name if object.nil?
      link = "[#{name}](#{@options[:request].base_url + "/entities/#{object.id}?current_milieu=#{@options[:milieu].id}"})"
    end

    return object.present? ? link : name
  end

  def list_item(content, list_type)
    "<li class=\"marker:text-fuchsia-800\">#{content}</li>"
  end

  def list(content, list_type)
    "<ul class=\"list-disc list-inside pl-5\">\n#{content}</ul>"
  end

  # To include features from other modules, like syntax highlighting with Rouge:
  # include Rouge::Plugins::Redcarpet # requires 'rouge/plugins/redcarpet'
  # def block_code(code, language)
  #   ... custom code highlighting logic ...
  # end
end