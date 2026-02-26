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
  
  belongs_to :language
  has_one :dialect, dependent: :destroy

  validates :eid, uniqueness: { scope: :milieu_id, message: "You have already created an entity with this eid." }

  SUBLATIONS = {
    [:person, :nation, :birth]  => ["societal", "member of"],
    [:person, :house, :birth] => ["societal", "of"],
    [:person, :person, :birth]  => ["familial", "child of"],
    [:person, :person, :marriage] => ["spoused", "spouse of"],
    
    [:person, :house, :adoption] => ["societal", "adopted of"],
    [:person, :house, :first] => ["societal", "first of"],
    [:person, :house, :second] => ["societal", "second of"],
    [:person, :house, :third] => ["societal", "third of"],
    [:person, :house, :exile] => ["societal", "exile of"],

    [:person, :person, :consorting]  => ["familial", "consort of"],
    [:person, :person, :marriage]  => ["familial", "spouse of"],

    [:house, :society, nil]  => ["political", "house of"],
    [:house, :nation, nil]  => ["political", "house of"],
    [:society, :nation, nil]   => ["political", "society of"],
    [:nation, :world, nil]   => ["political", "nation of"],
    [:unkown, :person, nil] => ["mysterious", "unknown relation of"]
  }

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

    
  def set_relation(event, superior, relkind = nil, public)
    rkind, rname = SUBLATIONS[[self.kind.to_sym, superior.kind.to_sym, relkind.nil? ? nil : relkind.to_sym]]
    rkind = rkind.nil? ? "unknown" : rkind
    rname = rname.nil? ? "unknown" : rkind
    relation = Relation.find_or_create_by(event: event, inferior: self, superior: superior, kind: rkind, name: rname, public: public=="public")
  end

  def mod_relation(event, superior, relkind, public)
    rkind, rname = SUBLATIONS[[self.kind.to_sym, superior.kind.to_sym, relkind.nil? ? nil : relkind.to_sym]]
    relation = self.superior_relations.where(superior_id: superior.id).sort.last
    relation.update!(kind: rkind, name: rname, public: public=="public")
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