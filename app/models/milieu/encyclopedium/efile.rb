class Efile < ApplicationRecord
  belongs_to :encyclopedium
  belongs_to :efolder
  has_many :events, dependent: :destroy
  after_create_commit :parse

  PROPERTIES = "---"
  HEADER = "#"
  CODE = "```"
  PRIVATE = "~"
  BLANK = ""
  STOP = -1
  
  def parse
    self.properties = {}
    @contents = {}
    parse_file
    self.contents = @contents
    self.save

    proc
  end
  
  def proc(target: nil)
    case self.properties["kind"]
    when "date" then proc_date
    when "entity" then proc_entity(target)
    end
  end

  def proc_entity(entity)
    return if entity.nil?
    entity.text = {pri: "", pub: ""}
    self.contents.each do |key, content|
      entity.text["pri"] += content["pri"]
      entity.text["pub"] += content["pub"]
    end
    entity.save
  end

  private
  
  def proc_date
    self.contents.keys.each do |key|
      code = {kinds: []}
      
      self.contents[key]["code"][1..].map{|x| code[:kinds] << x.split("|").map{|y| y.strip()}[0] }
      code[:insts] = self.contents[key]["code"][1..]
      code[:proc], code[:kind], code[:public] = self.contents[key]["code"].first.split("|")
      
      Event.create!(
        milieu: self.encyclopedium.milieu,
        ydate: self.encyclopedium.milieu.get_date_from_strdate(self.name),
        code: code[:insts], 
        kind: code[:kinds].join(","), 
        name: key, 
        public: code[:public] == "public",
        efile: self, 
        text: {pri: self.contents[key]["pri"], pub: self.contents[key]["pub"]}
      ) if code[:proc] == "proc"
    end
  end

  def parse_file
    context, @section = [""]*2
    @contents[""] = {code: [], pri: "", pub: ""}

    File.foreach(File.join(self.path, self.name)).with_index do |line, index|
      case context
      when BLANK then context = parse_line(line)
      when PROPERTIES then context = parse_properties(line)
      when CODE then context = line.starts_with?(CODE) ? BLANK : parse_code(line, index)
      when PRIVATE then context = line.starts_with?(PRIVATE) ? BLANK : parse_private(line)
      when STOP then return
      end
    end
  end
  
  def parse_line(line)
    return PROPERTIES if line.starts_with?(PROPERTIES)
    return CODE if line.starts_with?(CODE)
    return PRIVATE if line.starts_with?(PRIVATE)
    return parse_header(line) if line.starts_with?(HEADER)
    @contents[@section][:pub] += line
    BLANK
  end

  def parse_header(line)
    @contents.delete(@section) if @contents.dig(@section, :code).empty?
    @section = line.gsub(/^(?:#)*/,'').strip()
    @contents[@section] = {code: [], pri: "", pub: ""}
    BLANK
  end

  def parse_private(line)
    return BLANK if line.starts_with?(PRIVATE)
    @contents[@section][:pri] += line
    PRIVATE
  end

  def parse_properties(line)
    return BLANK if line.starts_with?(PROPERTIES)
    property = line.split(":").map{|x| x.strip()}
    self.properties[property.first] = property.second
    self.save
    PROPERTIES
  end

  def parse_code(line, index)
    return BLANK if line.starts_with?(CODE)
    @contents[@section][:code] << line.split("|").map{|x| x.strip()}.join("|")
    CODE
  end
end
