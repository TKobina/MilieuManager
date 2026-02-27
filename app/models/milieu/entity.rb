class Entity < ApplicationRecord
  include Comparable
  belongs_to :milieu
  belongs_to :reference, optional: true
  has_and_belongs_to_many :events
  
  has_many :properties, dependent: :destroy
  
  has_many :inferior_relations, class_name: "Relation", foreign_key: "superior_id", dependent: :destroy
  has_many :inferiors, through: :inferior_relations, source: :inferior
  
  has_many :superior_relations, class_name: "Relation", foreign_key: "inferior_id"
  has_many :superiors, through: :superior_relations, source: :superior, dependent: :destroy
  
  belongs_to :language, optional: true
  has_one :dialect, dependent: :destroy

  validates :eid, uniqueness: { scope: :milieu_id, message: "You have already created an entity with this eid." }

  def <=>(other)
    slang = self.language?
    return slang.sort(self.name, other.name) unless slang.nil? 
    olang = other.language? 
    return olang.sort(self.name, other.name) unless olang.nil? 
    Language.first.sort(self.name, other.name)
  end

  def language? 
    return self.language if self.language.present?
    return self.superiors.first.language? unless self.superiors.empty?
    nil
  end
  
  def dialect? = self.dialect.present? ? self.dialect : self.superiors.first.dialect?  

    
  def set_relation(event, superior, relkind, public)
    #rkind, rname = SUBLATIONS[[self.kind.to_sym, superior.kind.to_sym, relkind.nil? ? nil : relkind.to_sym]]
    relclass = Relclass.find_or_create_by(milieu: self.milieu, kind: relkind)
    relation = Relation.find_or_create_by(event: event, relclass: relclass, inferior: self, superior: superior, public: public)
  end

  def mod_relation(event, superior, relkind, public)
    #rkind, rname = SUBLATIONS[[self.kind.to_sym, superior.kind.to_sym, relkind.nil? ? nil : relkind.to_sym]]
    relclass = Relclass.find_or_create_by(milieu: self.milieu, kind: relkind)
    relation = self.superior_relations.where(superior: superior).sort.last
    binding.pry if relation.nil?
    relation.update!(event: event, relclass: relclass, public: public)
  end

  def proc_name
    Name::proc_name_society(self.name, self.superiors.where(kind: "society").first)
  end
  
  private

  def set_society(parenthouse: nil)
    event = self.events.last
    gender = self.properties.where(kind: "gender").first.value
    if !parenthouse.nil?
      peid = parenthouse.split("-").second
      phouse = self.milieu.entities.where(eid: peid).first
    else
      parent = self.superiors.first
      phouse = parent.kind != "person" ? parent : parent.superiors.where(kind: "society").first.superiors.first
    end
    society = phouse.inferiors.where(kind: "society").where("entities.name LIKE ?", "%#{gender}").first
    binding.pry if society.nil?
    society.events << self.events.last
    Relation.create!(event: event, superior: society, inferior: self, kind: "society", name: society.name)
    return society
  end

  # def gen_societies
  #   language = language?
  #   Dialect.create!(language: language, entity: self, name: self.name, occurrences: {names: 0, letters: {vowel: {}, consonant: {}, bridge: {}}, patterns: {}}, variances: {})
  #   HOUSESOCIETIES.each do |sname|
  #     society = Entity.create!(events: [self.events.first], milieu: self.milieu, eid: self.eid + sname, name: self.name + "-" + sname, kind: "society")
  #     Relation.create!(superior: self, inferior: society, kind: "political", name: "Society of")
  #     Dialect.create!(language: language, entity: society, name: society.name, occurrences: {names: 0, letters: {vowel: {}, consonant: {}, bridge: {}}, patterns: {}}, variances: {})

  #     parentsocieties = []
  #     self.superiors.where(kind: ["house", "nation"]).each{|sup| parentsocieties << sup.inferiors.where(kind: "society")}
  #     psociety = parentsocieties.flatten.find{|psoc|  psoc.name[-1] == sname[-1]}
  #     Relation.create!(superior: psociety, inferior: society, kind: "societal", name: "Chapter of") unless psociety.nil?
  #   end
  # end
end