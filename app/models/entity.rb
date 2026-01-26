class Entity < ApplicationRecord
  belongs_to :milieu
  
  has_and_belongs_to_many :events

  has_many :inferior_relations, class_name: "Relation", foreign_key: "superior_id", dependent: :destroy
  has_many :inferiors, through: :inferior_relations, source: :inferior
  
  has_many :superior_relations, class_name: "Relation", foreign_key: "inferior_id"
  has_many :superiors, through: :superior_relations, source: :superior
  
  has_one :language, dependent: :destroy
  has_one :dialect
  has_many :properties, dependent: :destroy
  
  validate :check_duplicate_entity

  class Former
    def initialize(event)
      @event = event
      @entity = Entity.new(milieu: event.milieu)
      @core = @event.name.split()
      @name, @gender = @core[0].split("-")
      
      @entity.name = @name
      @entity.events << @event
    end

    def event? = @event
    def entity? = @entity
    def core? = @core
    def name? = @name
    def gender? = @gender
  end

  def self.build(event)    
    former = Former.new(event)
    
    case event.kind
    when "Founding" then founding(former)
    when "Birth" then birth(former)
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

  def self.founding(former)
    entity = former.entity?
    entity.properties << Property.new(kind: "foundingdate", value: former.event?.ydate)
    org_kind, status = former.core?[1].split("-")
    entity.kind = org_kind

    case org_kind
    when "Nation"
      entity.save
      Language.create!(entity_id: entity.id, name: entity.name)
    when "House"
      entity.save
      pname = former.core?[3]
      parent = Entity.where(milieu: former.event?.milieu, name: pname).first
      parent.inferiors << entity
      Relation.last.update!(kind: "political", name: "nation")
      entity_status = Property.new(kind: "status", value: status)
      entity.properties << entity_status
      Dialect.create!(language: parent.language, entity: entity, name: former.name?)

      ["w", "n", "m"].each do |sgender|
        society = Entity.create!(milieu: former.event?.milieu, name: former.name? + "-" + sgender, kind: "Society")
        Dialect.create!(language: parent.language, entity: society, name: society.name)
        entity.inferiors << society
        Relation.last.update!(kind: "political", name: "house")
      end
    end
  end

  def self.birth(former)
    entity = former.entity?
    entity.kind = "Person"
    pname = former.core?[2]
    hname = former.core?[4]
    gender = Property.new(kind: "gender", value: former.gender?)
    entity.properties << gender
    entity.properties << Property.new(kind: "birthdate", value: former.event?.ydate)
    entity.save!

    if !pname.nil? && entity.name != pname
      parent = Entity.where(milieu: former.event?.milieu, name: pname).first
      parent.inferiors << entity if !pname.nil? && parent != entity
      parent.events << former.event?
      Relation.last.update!(kind: "familial", name: "parent")
    end

    hname = "Yldr" if hname == ""
    house = Entity.where(milieu: former.event?.milieu, name: hname).first
    house.inferiors << entity
    house.events << former.event?
    Relation.last.update!(kind: "political", name: "of")
  end
end