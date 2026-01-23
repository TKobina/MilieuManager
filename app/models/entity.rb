class Entity < ApplicationRecord
  belongs_to :milieu
  
  has_and_belongs_to_many :events, dependent: :destroy

  #has_and_belongs_to_many :superiors, class_name: "Relation", dependent: :destroy
  #has_and_belongs_to_many :inferiors, class_name: "Relation", dependent: :destroy

  has_many :inferior_relations, class_name: "Relation", foreign_key: "superior_id", dependent: :destroy
  has_many :inferiors, through: :inferior_relations, source: :inferior
  
  has_many :superior_relations, class_name: "Relation", foreign_key: "inferior_id", dependent: :destroy
  has_many :superiors, through: :superior_relations, source: :superior
  
  has_one :dialect
  has_many :properties
  
  validate :check_duplicate_entity
  after_create_commit :proc_new

  private

  def check_duplicate_entity
    if !Entity.includes(:milieu).where(kind: self.kind, name: self.name).empty?
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