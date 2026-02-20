class ObsidianImporterService

  PROPERTIES = "---"
  HEADER = "#"
  CODE = "```"
  PRIVATE = "~"
  BLANK = ""
  STOP = -1
  IGNORE = [
    "config.yml"
  ]

  def initialize(path, name, milieu)
    @files = {}
    @milieu = milieu
    import_obsidian(path, name)

    @milieu.proc_chronology
  end

  def import_obsidian(path, name)
    Rails.cache.write(@milieu.id.to_s + "personids", [], expires_in: 2.hours)
    puts "Discovering external directories"
    parse_folder(path, name)
    puts "Discovery complete"
    progressbar = ProgressBar.create(title: "Parsing files", total: @files.keys.count)
    @files.keys.sort.each{ |file| proc_file(file, @files[file]) ; progressbar.increment }

    puts "Collecting statistics on names..."
    Rails.cache.read(@milieu.id.to_s + "personids").each {|entid| Entity.find(entid).proc_name}
    

    ##ISSUES WITH ORDER OF PROCCING
    ##NEED TO PROC EVENTS FIRST, SO LANGUAGES & LETTERS GET BUILT
    ##CHECK SORTING OF DATES
    ##WHY IS NAME GETTING PROCCED BEFORE LANGUAGE?? SORTING HERE SHOULD RESOLVE THAT!
    puts "Parsing complete."
  end

  def parse_folder(path, name)
    entries = Dir.entries(File.join(path, name))
    entries.reject! { |x| IGNORE.include?(x) || x.start_with?(".") || x.start_with?("_") || x==name + ".md" }
    entries.each do |entry|
      if File.directory?(File.join(path, name, entry))
        parse_folder(File.join(path, name), entry) 
      else
        parse_file(File.join(path, name), entry) if entry.end_with?(".md")
      end
    end
  end

  def parse_file(path, name)
    @properties = {}
    @contents = {}
    context = ""
    @section = ""
    @contents[@section] = {code: [], pri: "", pub: ""}

    File.foreach(File.join(path, name)).with_index do |line, index|
      case context
      when BLANK then context = parse_line(line)
      when PROPERTIES then context = parse_properties(line)
      when CODE then context = line.starts_with?(CODE) ? BLANK : parse_code(line, index)
      when PRIVATE then context = line.starts_with?(PRIVATE) ? BLANK : parse_private(line)
      when STOP then return
      end
    end

    @files[name] = {}
    @files[name][:properties] = @properties
    @files[name][:contents] = @contents
  end

  def parse_line(line)
    #puts "parse_line: #{line}"
    return PROPERTIES if line.starts_with?(PROPERTIES)
    return CODE if line.starts_with?(CODE)
    return PRIVATE if line.starts_with?(PRIVATE)
    return parse_header(line) if line.starts_with?(HEADER)
    @contents[@section][:pub] += line
    BLANK
  end

  def parse_header(line)
    #puts "parse_header: #{line}"
    @contents.delete(@section) if !@contents.dig(@section, :code).present?
    @section = line.gsub(/^(?:#)*/,'').strip()
    @contents[@section] = {code: [], pri: "", pub: ""}
    BLANK
  end

  def parse_private(line)
    #puts "parse_private: #{line}"
    return BLANK if line.starts_with?(PRIVATE)
    @contents[@section][:pri] += line
    PRIVATE
  end

  def parse_properties(line)
    #puts "parse_properties: #{line}"
    return BLANK if line.starts_with?(PROPERTIES)
    property = line.split(":").map{|x| x.strip()}
    @properties[property.first] = property.second
    PROPERTIES
  end

  def parse_code(line, index)
    #puts "parse_code: #{line}"
    return BLANK if line.starts_with?(CODE)
    @contents[@section][:code] << line.split("|").map{|x| x.strip()}.join("|")
    CODE
  end

  def proc_file(filename, file, target: nil)
    case file[:properties]["kind"]
    when "date" then proc_date(filename, file)
    #when "event" then  proc_details(target)
    #when "entity" then proc_details(target)
    else
    end
  end

  def proc_date(filename, file)
    file[:contents].keys.each_with_index do |key, i|
      # params = {text: {pri: "", pub: ""}}
      # datestring, params[:name], params[:code], details = eparams
      # params[:text][:pri], params[:text][:pub], instructions = details.values
      # params[:code] += "\n" + instructions
      # params[:ydate] = Ydate.from_string(milieu, datestring)
      # params[:milieu] = milieu

      params = [
        filename, 
        key,
        file[:contents][key][:code].join("\n"), 
        details: {
          textpri: file[:contents][key]["pri"],
          textpub: file[:contents][key]["pub"],
          instructions: ""}]

      params = EventParamsService.call(@milieu, params)
      eve = Event.create!(params)
    end
  end
end