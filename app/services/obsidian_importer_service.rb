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
    file[:contents].keys.each do |key|
      code = {}

      code[:proc], code[:kind], code[:public] = file[:contents][key][:code]&.first&.split("|")

      #file[:contents][key][:code][1..]&.map{|x| code[:kinds] << x.split("|").map{|y| y.strip()}[0] }
      code[:instructions] = file[:contents][key][:code][1..]
      if code[:proc] == "proc"
        event = Event.new(
          milieu: @milieu,
          ydate: @milieu.get_date_from_strdate(filename),
          name: key, 
          public: code[:public] == "public",
          text: {pri: file[:contents][key]["pri"], pub: file[:contents][key]["pub"]}
        )

        code[:instructions].each {|instruction| Instruction.create!(event: event, code: instruction)}

        event.save
      end
    end
  end
end