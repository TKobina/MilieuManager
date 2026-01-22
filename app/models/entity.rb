class Entity < ApplicationRecord
  belongs_to :milieu
  
  has_and_belongs_to_many :events, dependent: :destroy

  #has_and_belongs_to_many :superiors, class_name: "Relation", dependent: :destroy
  #has_and_belongs_to_many :inferiors, class_name: "Relation", dependent: :destroy

  has_many :inferiors, class_name: "Relation", foreign_key: "superiors_id", dependent: :destroy
  has_many :active_relationships, through: :inferiors, source: :relation
  
  has_many :superiors, class_name: "Relation", foreign_key: "inferiors_id", dependent: :destroy
  has_many :passive_relationships, through: :superiors, source: :entity
  
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