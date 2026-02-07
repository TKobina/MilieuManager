class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  belongs_to :efile
  has_and_belongs_to_many :entities

  has_many :relations, dependent: :destroy
  has_many :properties, dependent: :destroy

  after_create_commit :proc_event

  def date?
    self.ydate.to_s
  end

  private

  def proc_event
    self.kind.split(",").each_with_index do |kind, index|
      case kind
      when "formation" then         Entity.new(events: [self]).formation(self.code[index])
      when "founding" then          Entity.new(events: [self]).founding(self.code[index])
      when "birth" then             Entity.new(events: [self]).birth(self.code[index])
      when "death" then             Entity.fetch(kind, self, self.code[index]).death(self, self.code[index])
      when "adoption" then          Entity.fetch(kind, self, self.code[index]).adoption(self, self.code[index])
      when "exiling" then return
      when "raising" then return
      when "claiming" then return
      when "disclaiming" then return
      when "hiring" then return
      when "firing" then return
      else return "Special!!"
      end
    end

    get_details
  end

  def get_details
    self.update!(text: {pri: "", pub: ""})    
    efile = self.efile.encyclopedium.efiles.where(name: self.name + ".md").first
    efile&.proc(target: self)
  end
end