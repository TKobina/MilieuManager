class Entity < ApplicationRecord
  include Comparable
  belongs_to :milieu
  belongs_to :event

  has_many :inferior_relations, class_name: "Relation", foreign_key: "superior_id", dependent: :destroy
  has_many :inferiors, through: :inferior_relations, source: :inferior
  
  has_many :superior_relations, class_name: "Relation", foreign_key: "inferior_id"
  has_many :superiors, through: :superior_relations, source: :superior

  has_many :events, class_name: "Event", foreign_key: "events_id"
  
  has_one :language, dependent: :destroy
  has_one :dialect, dependent: :destroy
  has_many :properties, dependent: :destroy
  
  validate :not_exists?

  #after_create_commit :proc_entity
  SOCIETIES = ["w","n","m"]

  def <=>(other) = self.language?.sort(self.name, other.name)
  def language? = self.language ? self.language : self.superiors.first.language?
  def dialect? = self.dialect ? self.dialect : self.superiors.first.dialect?  

  def formation(instruction)
    # formation | name-eid | kind | milieu
   instrs = instruction.split("|").map{|x| x.strip()}
   name, eid = instrs[1].split("-")
   self.milieu = self.event.milieu
   self.eid = eid
   self.name = name
   self.kind = instrs[2]
   self.public = false
   self.save!
  end

  def founding(instruction)
    # founding | name-eid | kind | status | parent-eid
    instrs = instruction.split("|").map{|x| x.strip()}
    name, eid = instrs[1].split("-")
    self.milieu = self.event.milieu
    self.eid = eid
    self.name = name
    self.kind = instrs[2]
    self.public = false
    self.save!

    self.properties << Property.new(kind: "founding date", value: self.event.ydate)
    self.properties << Property.new(kind: "status", value: instrs[3]) unless instrs[3] == ""
    self.properties.each{|x| x.event = self.event; x.save! }

    case instrs[2]
    when "world" then return
    when "nation"
      rkind = "political"
      rname = "Nation of"
      Language.create!(entity: self, name: self.name)
    when "house" 
      rkind = "political" 
      rname = "House of"
    end

    set_parent(instrs[4], rkind, rname)
    gen_societies
  end

  def birth(instruction)
    # birth | name-eid | gender | parent-eid
    instrs = instruction.split("|").map{|x| x.strip()}
    name, eid = instrs[1].split("-")
    self.milieu = self.event.milieu
    self.eid = eid
    self.name = name
    self.kind = "person"
    self.public = false
    self.save!

    set_parent(instrs[3], "familial", "child of")

    self.properties << Property.new(kind: "birth date", value: self.event.ydate)
    self.properties << Property.new(kind: "gender", value: instrs[2])
    self.properties.each{|x| x.event = self.event; x.save! }

    society = get_society
    Relation.create!(event: self.event, superior: society, inferior: self, kind: "societal", name: "member of") unless society.nil?
  end

  private
  
  def not_exists?
    self.milieu.entities.where(eid: self.eid).empty?
  end

  def set_parent(piden, rkind, rname)
    pname, peid = piden.split("-")
    parent = self.event.milieu.entities.where(eid: peid).first
    unless parent.nil?
      Relation.create!(event: self.event, superior: parent, inferior: self, kind: rkind, name: rname)
      return parent
    end
  end

  def gen_societies
    language = language?
    Dialect.create!(language: language, entity: self, name: self.name)
    SOCIETIES.each do |sname|
      society = Entity.create!(event: self.event, milieu: self.milieu, eid: self.eid + sname, name: self.name + "-" + sname, kind: "society")
      Relation.create!(event: self.event, superior: self, inferior: society, kind: "political", name: "Society of")
      Dialect.create!(language: language, entity: society, name: society.name)
    end
  end

  def get_society
    gender = self.properties.where(kind: "gender").first.value
    parent = self.superiors.first
    phouse = parent.kind!="person" ? parent : parent.superiors.where(kind: "society").first.superiors.first
    phouse.inferiors.where(kind: "society").where("entities.name LIKE ?", "%#{gender}").first
  end
end