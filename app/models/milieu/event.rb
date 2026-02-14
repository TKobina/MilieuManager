class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  has_and_belongs_to_many :entities

  has_many :relations, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :instructions, dependent: :destroy

  after_create_commit :proc_instructions

  def date?
    self.ydate.to_s
  end

  private

  def proc_instructions
    self.instructions.each {|instruction| instruction.proc }
    #get_details
  end

  def get_details
    #self.update!(text: {pri: "", pub: ""})    
    #efile = self.efile.encyclopedium.efiles.where(name: self.name + ".md").first
    #efile&.proc(target: self)
  end
end