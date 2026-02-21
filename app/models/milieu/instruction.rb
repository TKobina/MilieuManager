class Instruction < ApplicationRecord
  include Comparable
  belongs_to :event

  after_create_commit :set_kind

  KINDS = [
  "formation",
  "founding",
  "birth",
  "death",
  "adoption",
  "exiling",
  "raising",
  "claiming",
  "disclaiming",
  "hiring",
  "firing",
  "statadd",
  "statchange",
  "special"]

  def <=>(other) = self.i <=> other.i
  def set_kind = self.update!(kind: self.code.split("|").first)
  def proc_instruction 
    send(self.kind.to_sym) if self.code.present? && KINDS.include?(self.kind)
  end

  def formation
    # formation | name-eid | kind | milieu | public
    _, nameid, entkind, _, public = self.code.split("|") 
    name, eid = nameid.split("-")
    ent = Entity.create!(
      name: name, 
      eid: eid, 
      milieu: self.event.milieu, 
      kind: entkind, 
      text: {pri: "", pub: ""},
      public: public == "public",
      events: [self.event])
    ent.properties << Property.new(kind: "formation date", value: self.event.ydate.to_s)
    ent.events << self.event unless ent.events.include?(self.event)
  end

  def founding
    # founding | name-eid | kind | status | parent-eid | Language (if Nation) | public  |
    _, nameid, entkind, status, pareid, lang, public = self.code.split("|") 
    name, eid  = nameid.split("-")
    _, pareid  = pareid.split("-")
    parent = Entity.where(eid: pareid).first
    ent = Entity.create!(
      name: name, 
      eid: eid, 
      milieu: self.event.milieu, 
      kind: entkind, 
      text: {pri: "", pub: ""},
      public: public == "public",
      events: [self.event])
      
    ent.properties << Property.new(event: self.event, kind: "founding date", value: self.event.ydate.to_s)
    ent.properties << Property.new(event: self.event, kind: "status", value: status) if status.present?
    ent.set_relation(self.event, parent)
    ent.events << self.event unless ent.events.include?(self.event)
    parent.events << self.event unless parent.events.include?(self.event)

    Language.find_or_create_by(name: lang, milieu: ent.milieu).update!(entity: ent) if entkind == "nation"
  end

  def birth
    # birth | name-eid | gender | parent-eid | public
    _, nameid, gender, pareid, public = self.code.split("|")
    _, pareid  = pareid.split("-")
    parent = Entity.where(eid: pareid).first

    name, eid = nameid.split("-")
    
    ent = Entity.create!(
      milieu: self.event.milieu,
      eid: eid,
      name: name,
      kind: "person",
      text: {pri: "", pub: ""},
      public: public == "public",
      events: [self.event])
      
    ent.set_relation(self.event, parent, "birth")
    ent.events << self.event unless ent.events.include?(self.event)
    parent.events << self.event unless parent.events.include?(self.event)

    unless ["world","nation","house","society"].include?(parent.kind)
      phouse = parent.superiors.where(kind: ["world","nation","house"]).last
      ent.set_relation(self.event, phouse, "birth")
      phouse.events << self.event unless phouse.events.include?(self.event)
    end

    ent.properties << Property.new(event: self.event, kind: "birth date", value: self.event.ydate.to_s)
    ent.properties << Property.new(event: self.event, kind: "gender", value: gender)
  end

  def death
    # death | name-eid | public
    _, nameid, public = self.code.split("|")
    eid = nameid.split("-").second
    ent = Entity.where(eid: eid).first
    ent.properties << Property.new(event: self.event, kind: "death date", value: self.event.ydate.to_s)

    ent.events << self.event unless ent.events.include?(self.event)
  end

  def adoption
    # # adoption | entity-eid (house, society) | name-eid | newname-eid | public
    _, adopterid, oldnameid, newnameid, public  = self.code.split("|")
    _, aeid = adopterid.split("-")
    oldname, eid = oldnameid.split("-")
    newname, _ = newnameid&.split("-")

    dopter = Entity.where(eid: aeid).first
    doptee = Entity.where(eid: eid).first

    dopter.events << self.event unless dopter.events.include?(self.event)
    doptee.events << self.event unless doptee.events.include?(self.event)

    doptee.update!(name: newname) if !newname.nil?
    doptee.set_relation(self.event, dopter, "adoption")
  end

  def exiling
  end

  def raising
    # raising | entity-eid| name-eid | title | newname-eid | public
    _, raiserid, oldnameid, title, newnameid, public  = self.code.split("|")
    _, reid = raiserid.split("-")
    oldname, eid = oldnameid.split("-")
    newname, _ = newnameid&.split("-")

    raiser = Entity.where(eid: reid).first
    ent = Entity.where(eid: eid).first

    ent.events << self.event unless ent.events.include?(self.event)
    raiser.events << self.event unless raiser.events.include?(self.event)

    ent.update!(name: newname) if !newname.nil?
    ent.mod_relation(self.event, raiser, title)
  end

  def claiming
  end

  def disclaiming
  end

  def hiring
  end

  def firing
  end

  def status_change
    
  end

  def special
    
  end

end
