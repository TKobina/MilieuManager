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
  def language? = self.language ? self.language : self.superiors.first.language?
  def dialect? = self.dialect ? self.dialect : self.superiors.first.dialect?  

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

    set_society(parenthouse: instrs[4])
    Rails.cache.write("personids", Rails.cache.read("personids") << self.id) unless self.name == "unknown"
  end

  def proc_name
    Name::proc_name_society(self, self.superiors.where(kind: "society").first)
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
      Relation.create!(event: self.events.first, superior: parent, inferior: self, kind: rkind, name: rname)
      return parent
    end
  end

  def set_society(parenthouse: nil)
    gender = self.properties.where(kind: "gender").first.value
    if !parenthouse.nil?
      phousename, peid = parenthouse.split("-")
      phouse = self.milieu.entities.where(eid: peid).first
    else
      parent = self.superiors.first
      phouse = parent.kind != "person" ? parent : parent.superiors.where(kind: "society").first.superiors.first
    end
    society = phouse.inferiors.where(kind: "society").where("entities.name LIKE ?", "%#{gender}").first
    Relation.create!(event: self.events.first, superior: society, inferior: self, kind: "societal", name: "member of")
    return society
  end

  def gen_societies
    language = language?
    Dialect.create!(language: language, entity: self, name: self.name, occurances: {letters: {}, patterns: {}}, variances: {})
    HOUSESOCIETIES.each do |sname|
      society = Entity.create!(events: [self.events.first], milieu: self.milieu, eid: self.eid + sname, name: self.name + "-" + sname, kind: "society")
      Relation.create!(event: self.events.first, superior: self, inferior: society, kind: "political", name: "Society of")
      Dialect.create!(language: language, entity: society, name: society.name, occurances: {letters: {}, patterns: {}}, variances: {})
    end
  end
end