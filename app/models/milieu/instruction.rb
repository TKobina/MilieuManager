class Instruction < ApplicationRecord
  include ActiveModel::Callbacks

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
    entities = send(self.kind.to_sym) if self.code.present? && KINDS.include?(self.kind)
    if entities.present?
      entities.each { |ent| ent.events << self.event unless ent.nil? || ent.events.include?(self.event) }
    end
  end

  def formation
    # formation | name-eid | kind | creator-eid | public
    _, nameid, entkind, creatoreid, public = self.code.split("|") 
    name, eid = nameid.split("-")
    ent = Entity.create!(
      name: name, 
      eid: eid, 
      milieu: self.event.milieu, 
      kind: entkind, 
      public: public == "public",
      events: [self.event],
      reference: Reference.find_or_create_by(milieu: self.event.milieu, eid: eid))
    ent.properties << Property.new(kind: "formation date", value: self.event.ydate.to_s)

    creator = fetch_entity(creatoreid)

    [ent, creator]
  end

  def founding
    # founding | name-eid | kind | status | parent-eid | Language (if Nation) | public  |
    _, nameid, entkind, status, pareid, lang, public = self.code.split("|") 
    name, eid  = nameid.split("-")

    parent = fetch_entity(pareid)
    ent = Entity.create!(
      name: name, 
      eid: eid, 
      milieu: self.event.milieu, 
      kind: entkind, 
      public: public == "public",
      events: [self.event],
      reference: Reference.find_or_create_by(milieu: self.event.milieu, eid: eid))
    ent.properties << Property.new(event: self.event, kind: "founding date", value: self.event.ydate.to_s)
    ent.properties << Property.new(event: self.event, kind: "status", value: status) if status.present?
    ent.set_relation(self.event, parent)
    
    Language.find_or_create_by(name: lang, milieu: ent.milieu).update!(entity: ent) if entkind == "nation"

    [ent, parent]
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
      public: public == "public",
      events: [self.event],
      reference: Reference.find_or_create_by(milieu: self.event.milieu, eid: eid))

    parent = fetch_entity(pareid)

    ent.set_relation(self.event, parent, "birth")

    unless ["world","nation","house","society"].include?(parent.kind)
      phouse = parent.superiors.where(kind: ["world","nation","house"]).last
      ent.set_relation(self.event, phouse, "birth")
      phouse.events << self.event unless phouse.events.include?(self.event)
    end

    ent.properties << Property.new(event: self.event, kind: "birth date", value: self.event.ydate.to_s)
    ent.properties << Property.new(event: self.event, kind: "gender", value: gender)
    
    [ent, parent]
  end

  def death
    # death | name-eid | public
    _, nameid, public = self.code.split("|")
    ent = fetch_entity(nameid)
    ent.properties << Property.new(event: self.event, kind: "death date", value: self.event.ydate.to_s)

    [ent]
  end

  def adoption
    # # adoption | entity-eid (house, society) | name-eid | newname-eid | public
    _, adopterid, oldnameid, newnameid, public  = self.code.split("|")
    newname = newnameid&.split("-")&.first

    dopter = fetch_entity(adopterid)
    doptee = fetch_entity(oldnameid)

    doptee.update!(name: newname) if !newname.nil?
    doptee.set_relation(self.event, dopter, "adoption")

    [dopter, doptee]
  end

  def exiling
    # exile | entity-eid | name-eid | newname-eid | public
    _, exilerid, oldnameid, newnameid, public  = self.code.split("|")
    newname = newnameid&.split("-")&.first
    
    exiler = fetch_entity(exilerid)
    ent = fetch_entity(oldnameid)

    ent.update!(name: newname) if !newname.nil?
    ent.mod_relation(self.event, exiler, "exile")

    [exiler, ent]
  end

  def raising
    # raising | entity-eid| name-eid | title | newname-eid | public
    _, raiserid, oldnameid, title, newnameid, public  = self.code.split("|")
    newname = newnameid&.split("-")&.first

    raiser = fetch_entity(raiserid)
    ent = fetch_entity(oldnameid)

    ent.update!(name: newname) if !newname.nil?
    ent.mod_relation(self.event, raiser, title)

    [raiser, ent]
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
    []
  end

  private

  def fetch_entity(nameid) = Entity.where(eid: nameid.split("-").second).first
end
