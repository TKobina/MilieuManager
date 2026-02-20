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
  end

  def founding
    # founding | name-eid | kind | status | parent-eid | Language (if Nation) | public  |
    _, nameid, entkind, status, pareid, lang, public = self.code.split("|") 
    name, eid  = nameid.split("-")
    ent = Entity.create!(
      name: name, 
      eid: eid, 
      milieu: self.event.milieu, 
      kind: entkind, 
      text: {pri: "", pub: ""},
      public: public == "public",
      events: [self.event])

    ent.properties << Property.new(kind: "founding date", value: self.event.ydate.to_s)
    ent.properties << Property.new(kind: "status", value: status) if status.present?
    ent.set_relation(pareid)

    Language.find_or_create_by(name: lang, milieu: ent.milieu).update!(entity: ent) if entkind == "nation"
  end

  def birth
    # birth | name-eid | gender | parent-eid | public
    _, nameid, gender, pareid, public = self.code.split("|") 
    name, eid = nameid.split("-")
    ent = Entity.create!(
      milieu: self.event.milieu,
      eid: eid,
      name: name,
      kind: "person",
      text: {pri: "", pub: ""},
      public: public == "public",
      events: [self.event])
    ent.set_relation(pareid, "birth")

    ent.properties << Property.new(kind: "birth date", value: self.event.ydate.to_s)
    ent.properties << Property.new(kind: "gender", value: gender)
  end

  def death
    #Entity.fetch(kind, self, self.code[index]).death(self, self.code[index])
    #    self.events << event
    #self.properties << Property.new(kind: "death date", value: self.events.last.ydate)
    #self.save
  end

  def adoption
    # Entity.fetch(kind, self, self.code[index]).adoption(self, self.code[index])
    # # adoption | entity-eid (house, society) | name-eid | newname-eid
    # instrs = instruction.split("|")
    # name = instrs[3]&.split("-")&.first
    # self.name = name if name.present?
    # self.events << event
    # self.save
    # self.set_society(parenthouse: instrs[1])
    # self.properties << Property.new(event: event, kind: "adoption", value: "by " + instrs[1].split("-").first)
  end

  def exiling
  end

  def raising
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
