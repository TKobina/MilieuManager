class Entity < ApplicationRecord
  belongs_to :milieu
  
  has_and_belongs_to_many :events

  has_many :inferior_relations, class_name: "Relation", foreign_key: "superior_id", dependent: :destroy
  has_many :inferiors, through: :inferior_relations, source: :inferior
  
  has_many :superior_relations, class_name: "Relation", foreign_key: "inferior_id", dependent: :destroy
  has_many :superiors, through: :superior_relations, source: :superior
  
  has_one :language
  has_one :dialect
  has_many :properties
  
  validate :check_duplicate_entity
  after_create_commit :proc_new

  def self.build(event)
    #Nation gets a language
    #House gets a dialect
    #House belongs to Nation
    #Person belongs to House (or unhoused)
    
    entity = Entity.new(milieu: event.milieu)
    kind = event.kind
    core = event.name.split()
    name, gender = core[0].split("-")
    
    entity.name = name

    birthdate = Property.new(kind: "birthdate", value: event.ydate)
    entity.properties << birthdate
    entity.events << event

    p core
    case event.kind
    when "Founding"
      pname = core[1] == "Nation" ? nil : core[3]
    when "Birth"
      entity.kind = "Person"
      pname = core[2]
      gender = Property.new(kind: "gender", value: gender)
      entity.properties << gender
    end

    entity.kind = kind
    entity.save
    
    if !pname.nil?
      parent = Entity.where(milieu: event.milieu, name: pname).first
      binding.pry
      parent.inferiors << entity if !pname.nil? && parent != entity
      parent.events << event if !pname.nil? && parent != entity
    end
  end

  private

  def check_duplicate_entity
    if !Entity.where(milieu: self.milieu, kind: self.kind, name: self.name).empty?
      errors.add("", "#{self.kind} | #{self.name} already exists")
    end
  end

  def proc_new
    #LEDLANG.add_entity(user, self)
  end

  def <=>(other)
    #LEDLANG.sort(self.name, other.name)
  end
end