class Event < ApplicationRecord
  belongs_to :milieu
  has_many :relations
  has_and_belongs_to_many :entities
  belongs_to :ydate

  after_create_commit :proc_new

  private

  def proc_new
    case self.kind
    when "birth" then birth
    end
  end

  def birth
    puts "BIRTH WAS PROCCED!!!!"

    #Create Child Entity
      #Create property (birthdate) -> child
      #event -> child.events
      #child -> event???
      #create relation -> mother
  end
end
