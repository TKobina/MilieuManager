class Entity < ApplicationRecord
  include Comparable
  belongs_to :milieu
  has_and_belongs_to_many :events

  has_many :inferior_relations, class_name: "Relation", foreign_key: "superior_id", dependent: :destroy
  has_many :inferiors, through: :inferior_relations, source: :inferior
  
  has_many :superior_relations, class_name: "Relation", foreign_key: "inferior_id"
  has_many :superiors, through: :superior_relations, source: :superior
  
  has_one :language, dependent: :destroy
  has_one :dialect, dependent: :destroy
  has_many :properties, dependent: :destroy
  
  validate :not_exists?

  after_create_commit :get_details

  HOUSESOCIETIES = ["w","n","m"]

  def <=>(other) = self.language?.sort(self.name, other.name)
  def language? = self.language.present? ? self.language : self.superiors.first.language?
  def dialect? = self.dialect.present? ? self.dialect : self.superiors.first.dialect?  

  def self.fetch(kind, event, instruction)
    instrs = instruction.split("|")
    case kind
    when "adoption" then return get_entity(instrs[2].split("-").second)
    when "death" then return get_entity(instrs[1].split("-").second)
    end
  end

  ## ----------------------------------CORE ENTITY EVENTS---------------------------------------
  def formation(instruction)
    # formation | name-eid | kind | milieu
    instrs = instruction.split("|")
    name, eid = instrs[1].split("-")
    self.milieu = self.events.first.milieu
    self.eid = eid
    self.name = name
    self.kind = instrs[2]
    self.public = false
    self.save!
  end

  def founding(instruction)
    # founding | name-eid | kind | status | parent-eid | Language (if Nation)
    instrs = instruction.split("|")
    name, eid = instrs[1].split("-")
    self.milieu = self.events.first.milieu
    self.eid = eid
    self.name = name
    self.kind = instrs[2]
    self.public = false
    self.save!

    self.properties << Property.new(kind: "founding date", value: self.events.first.ydate)
    self.properties << Property.new(kind: "status", value: instrs[3]) unless instrs[3] == ""
    self.properties.each{|x| x.event = self.events.first; x.save! }

    case instrs[2]
    when "world" then return
    when "nation"
      rkind = "political"
      rname = "Nation of"
      Language.create!(entity: self, name: instrs[5])
    when "house" 
      rkind = "political" 
      rname = "House of"
    end

    set_parent(instrs[4], rkind, rname)
    gen_societies
  end

  def birth(instruction)
    # birth | name-eid | gender | parent-eid | house-eid
    instrs = instruction.split("|")
    name, eid = instrs[1].split("-")
    self.milieu = self.events.first.milieu
    self.eid = eid
    self.name = name
    self.kind = "person"
    self.public = false
    self.save!

    set_parent(instrs[3], "familial", "child of")

    self.properties << Property.new(kind: "birth date", value: self.events.first.ydate)
    self.properties << Property.new(kind: "gender", value: instrs[2])
    self.properties.each{|x| x.event = self.events.first; x.save! }

    return self if self.name == "unknown"
    set_society(parenthouse: instrs[4])
    Rails.cache.write("personids", Rails.cache.read("personids") << self.id)
  end
  
  def death (event, instrs)
    self.events << event
    self.properties << Property.new(kind: "death date", value: self.events.last.ydate)
    self.save
  end
  
  def adoption(event, instruction)
    # adoption | entity-eid (house, society) | name-eid | newname-eid
    instrs = instruction.split("|")
    name = instrs[3]&.split("-")&.first
    self.name = name if name.present?
    self.events << event
    self.save
    self.set_society(parenthouse: instrs[1])
    self.properties << Property.new(event: event, kind: "adoption", value: "by " + instrs[1].split("-").first)
  end



  ## ------------------------------------SUPPORTING METHODS--------------------------------------------

  def proc_name
    Name::proc_name_society(self.name, self.superiors.where(kind: "society").first)
  end
  
  def self.get_entity(eid)
    Entity.where(eid: eid).first
  end

  private

  
  def not_exists?
    self.milieu.entities.where(eid: self.eid).empty?
  end

  def get_details
    self.update!(text: {pri: "", pub: ""})    
    efile = self.events.first.efile.encyclopedium.efiles.where(name: self.name + "-" + self.eid + ".md").first
    efile&.proc(target: self)
  end

  def set_parent(piden, rkind, rname)
    pname, peid = piden.split("-")
    parent = self.events.first.milieu.entities.where(eid: peid).first
    unless parent.nil?
      parent.events << self.events.last
      Relation.create!(event: self.events.first, superior: parent, inferior: self, kind: rkind, name: rname)
      return parent
    end
  end

  def set_society(parenthouse: nil)
    gender = self.properties.where(kind: "gender").first.value
    if !parenthouse.nil?
      peid = parenthouse.split("-").second
      phouse = self.milieu.entities.where(eid: peid).first
    else
      parent = self.superiors.first
      phouse = parent.kind != "person" ? parent : parent.superiors.where(kind: "society").first.superiors.first
    end
    society = phouse.inferiors.where(kind: "society").where("entities.name LIKE ?", "%#{gender}").first
    society.events << self.events.last
    Relation.create!(event: self.events.last, superior: society, inferior: self, kind: "society", name: society.name)
    return society
  end

  def gen_societies
    language = language?
    p "generating dialect for #{self.name}"
    Dialect.create!(language: language, entity: self, name: self.name, occurrences: {names: 0, letters: {vowel: {}, consonant: {}, bridge: {}}, patterns: {}}, variances: {})
    HOUSESOCIETIES.each do |sname|
      society = Entity.create!(events: [self.events.first], milieu: self.milieu, eid: self.eid + sname, name: self.name + "-" + sname, kind: "society")
      Relation.create!(event: self.events.first, superior: self, inferior: society, kind: "political", name: "Society of")
      Dialect.create!(language: language, entity: society, name: society.name, occurrences: {names: 0, letters: {vowel: {}, consonant: {}, bridge: {}}, patterns: {}}, variances: {})

      parentsocieties = []
      self.superiors.where(kind: ["house", "nation"]).each{|sup| parentsocieties << sup.inferiors.where(kind: "society")}
      psociety = parentsocieties.flatten.find{|psoc|  psoc.name[-1] == sname[-1]}
      Relation.create!(event: self.events.first, superior: psociety, inferior: society, kind: "societal", name: "Chapter of") unless psociety.nil?
    end
  end
end