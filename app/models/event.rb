class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  
  has_many :relations
  has_and_belongs_to_many :entities

  after_create_commit :proc_new

  class Details
    def initialize(path:, date:, name:, text: "", filemod: "", textstart: 0)
      @date = date
      @summ = name
      @text = text
      @filemod = filemod
      @path = path
      @textstart = textstart
    end
    def date(eventdate) = @date = eventdate
    def name(summ) = @summ = summ
    def text(eventtext) = @text = eventtext
    def filemod(time) = @modtime = time
    def path(path) = @path = path

    def date? = @date
    def name? = @summ
    def text? = @text
    def filemod? = @filemod
    def path? = @path
    def textstart? = @textstart
  end

  def self.kinds?
    [
      "Birth",
      "Death",
      "Adoption",
      "Raising",
      "Organizing",
      "Founding",
      "Bonding",
      "Consorting",
      "Marriage",
      "Divorce"]
  end

  def self.check_obsidian
    @filetree = Obsidian.proc_records("Events", Ydate.all)
    @filetree[:files].sort.each do |filename, filepath|
      filetext = File.read(filepath)
      filemod = File.mtime(filepath)
      positions_h = filetext.enum_for(:scan, /^(?:#)(.*)$/).map { Regexp.last_match.begin(0) }
      positions_l = filetext.enum_for(:scan, /$/).map { Regexp.last_match.begin(0) }
      ids = []
      
      positions_h.each do |i_0|
        j= positions_l.select { |element| element > i_0 }.first
        i_1 = positions_h.select { |element| element > i_0 }.first 
        i_1 ||= -1

        details = Details.new(
          path: filepath,
          date: filename, 
          filemod: filemod, 
          name: filetext[i_0, j].remove("#").strip(),
          text: filetext[j+1, i_1 - (j - i_0)],
          textstart: j)

        ids << parse_events(details)
      end

      ids.reverse_each do |index, id|
        filetext.insert(index ||= -1," | " + id.to_s)
      end

      File.write(filepath, filetext, mode: 'w')
    end
  end

  def date?
    self.ydate.to_s
  end

  private

  def self.parse_events(details)
    core = details.name?.split("|").map {|field| field.strip()}
    id = core[-1].to_i

    #if event already exists
    if id > 0
      ##CHECK FOR NAME CHANGES AND SUCH??
      update_event(details, id, core)
    end

    special = !self.kinds?.include?(core[0])

    event = Event.new
    event.kind = special ? "Special" : core[0]
    event.milieu = Milieu.first
    event.name = details.name?.remove("[","]")
    event.ydate = event.milieu.get_date_from_strdate(details.date?)
    
    event.details = special ? parse_special(details) : details.text?
    
    event.lastupdate = details.filemod?
    event.save

    return [details.textstart?, event.id]
  end

  def self.update_event(details, core)
    p "NEED TO ADD FUNCTIONALITY TO CHECK FILE MTIME VS EVENT MOD"
  end

  def self.parse_special(details)
    if details.text?.nil? || details.text.empty?
      detailfile = details.name?.remove("[","]") << ".md"
      detailpath = @filetree[:directories]["Details"][:files][detailfile]
      
      return "" if detailpath.nil?
      
      modtime = File.mtime(detailpath)

      
      details.filemod(modtime) if modtime > details.filemod?
      return File.read(detailpath)
    end
  end

  def proc_new
    case self.kind
    when "Birth" then birth
    when "Formation" then formation
    end
  end

  def birth
    puts "BIRTH WAS PROCCED"

    #Create Child Entity
      #Create property (birthdate) -> child
      #event -> child.events
      #child -> event???
      #create relation -> mother
  end

  def formation
    puts "FORMATION WAS PROCCED"
  end
end
