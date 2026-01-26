class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  
  has_many :relations
  has_and_belongs_to_many :entities

  after_create_commit :proc_event

  def date?
    self.ydate.to_s
  end

  class Details
    def initialize(milieu:, path:, date:, name:, text: "", filemod: "", textstart: 0)
      @milieu = milieu
      @date = date
      @summ = name
      @text = text
      @filemod = filemod
      @path = path
      @textstart = textstart
    end
    # def date(eventdate) = @date = eventdate
    # def name(summ) = @summ = summ
    # def text(eventtext) = @text = eventtext
    # def filemod(time) = @modtime = time
    # def path(path) = @path = path
    def milieu? = @milieu
    def date? = @date
    def name? = @summ
    def text? = @text
    def filemod? = @filemod
    def path? = @path
    def textstart? = @textstart
  end

  def self.kinds?
    [
      "Founding",
      "Birth",
      "Death",
      "Adoption",
      "Raising",
      "Hiring",
      "Firing",
      "Bonding",
      "Consorting",
      "Marriage",
      "Divorce"]
  end

  def self.check_obsidian(milieu)
    @filetree = Obsidian.proc_records("Events", Ydate.all)
    @filetree[:files].sort.each do |filename, filepath|
      filetext = File.read(filepath)
      filemod = File.mtime(filepath)
      positions_h = filetext.enum_for(:scan, /^(?:#)(.*)$/).map { Regexp.last_match.begin(0) }
      positions_l = filetext.enum_for(:scan, /\R/).map { Regexp.last_match.begin(0) }
      ids = []
      
      positions_h.each do |i_0|
        i_1 = positions_h.select { |element| element > i_0 }.first 
        i_1 ||= filetext.length
        j= positions_l.select { |element| element > i_0 }.first
        j ||= filetext.length

        details = Details.new(
          milieu: milieu,
          path: filepath,
          date: filename, 
          filemod: filemod, 
          name: filetext[i_0..j].remove("#").strip(),
          text: filetext[j..i_1].remove("#").strip(),
          textstart: j)

        id = details.name?.split("|")[-1].strip().to_i

        idindex = parse_events(details)
        ids << idindex if id == 0
      end

      ids.reverse_each do |index, id|
        filetext.insert(index ||= -1," | " + id.to_s)
      end

      File.write(filepath, filetext, mode: 'w')
    end
  end

  private

  def self.parse_events(details)
    core = details.name?.split("|").map {|field| field.strip()}
    id = core[-1].to_i
    special = !self.kinds?.include?(core[0])

    #if event already exists
    if id > 0
      event = details.milieu?.events.find(id)
    else
      event = Event.new
      event.kind = special ? "Special" : core[0]
      event.milieu = details.milieu?
      name = details.name?.remove("[","]")
      event.name = special ? name : name.split("|")[1].strip()
      event.ydate = event.milieu.get_date_from_strdate(details.date?)      
      event.details = special ? parse_special(details) : details.text?
      event.lastupdate = details.filemod?
    end

    event.save

    return [details.textstart?, event.id]
  end

  def self.update_event(details, event, core)
    p "NEED TO ADD FUNCTIONALITY TO CHECK FILE MTIME VS EVENT MOD"
  end

  def self.parse_special(details)
    if details.text?.nil? || details.text?.empty?
      detailfile = details.name?.remove("[","]") << ".md"
      detailpath = @filetree[:directories]["Details"][:files][detailfile]
      
      return "" if detailpath.nil?

      modtime = File.mtime(detailpath)

      details.filemod(modtime) if modtime > details.filemod?
      return File.read(detailpath)
    end
  end

  def proc_event
    case self.kind
    when "Formation", "Birth" then Entity.build(self)
    when "Death" then return
    when "Adoption" then return
    when "Raising" then return
    when "Bonding" then return
    when "Hiring" then return
    when "Firing" then return
    when "Consorting" then return
    when "Marriage" then return
    when "Divornce" then return
    end
  end
end