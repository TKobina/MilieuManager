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

  def self.build(event)    
    entity = Entity.new(milieu: event.milieu)
    core = event.name.split()
    name, gender = core[0].split("-")
    
    entity.name = name
    entity.events << event
    
    case event.kind
    when "Founding"
      entity.properties << Property.new(kind: "foundingdate", value: event.ydate)
      org_kind, status = core[1].split("-")
      entity.kind = org_kind
      case org_kind
      when "Nation"
        entity.save
        Language.create!(entity_id: entity.id, name: entity.name)
      when "House"
        entity.save
        pname = core[3]
        parent = Entity.where(milieu: event.milieu, name: pname).first
        entity_status = Property.new(kind: "status", value: status)
        entity.properties << entity_status
        Dialect.create!(language: parent.language, entity: entity, name: name)

        ["w", "n", "m"].each do |sgender|
          society = Entity.create!(milieu: event.milieu, name: name + "-" + sgender, kind: "Society")
          Dialect.create!(language: parent.language, entity: society, name: society.name)
          entity.inferiors << society
        end
      end
    when "Birth"
      entity.kind = "Person"
      pname = core[2]
      gender = Property.new(kind: "gender", value: gender)
      entity.properties << gender
      entity.properties << Property.new(kind: "birthdate", value: event.ydate)
      entity.save!
    end
    
    if !pname.nil?
      pname = "Yldr" if entity.name == pname
      parent = Entity.where(milieu: event.milieu, name: pname).first
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

  def <=>(other)
    #LEDLANG.sort(self.name, other.name)
  end
end