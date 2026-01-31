class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  belongs_to :efile
  
  has_many :entities, dependent: :destroy
  has_many :relations, dependent: :destroy
  has_many :properties, dependent: :destroy

  after_create_commit :proc_event

  def date?
    self.ydate.to_s
  end

  private

  def proc_event
    instruction = code.split("\n")
    self.kind.split(",").each_with_index do |kind, index|
      case kind
      when "formation" then         Entity.new(event: self).formation(instruction[index])
      when "founding" then          Entity.new(event: self).founding(instruction[index])
      when "birth" then             Entity.new(event: self).birth(instruction[index])
      when "death" then return
      when "adoption" then return
      when "raising" then return
      when "bonding" then return
      when "hiring" then return
      when "firing" then return
      when "consorting" then return
      when "marriage" then return
      when "divorce" then return
      else return "Special!!"
      end
    end
  end
end