class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  
  has_and_belongs_to_many :entities

  has_many :instructions, dependent: :destroy
  accepts_nested_attributes_for :instructions, allow_destroy: true

  def date? = self.ydate.to_s
  def <=>(other) = self.ydate == other.ydate ? self.i <=> other.i : self.ydate <=> other.ydate

  def update_event
    cproc, ckind, cpublic = self.code&.first&.split("|")
    self.update!(proc: cproc == "proc", public: cpublic == "public")
    #self.proc = cproc == "proc"
    #self.public = cpublic == "public"
    self.instructions.destroy_all
    self.code[1..].each_with_index {|instruction, i| Instruction.create!(event: self, code: instruction, i: i)}
  end

  def proc_event
    cproc, ckind, cpublic = self.code&.first&.split("|")
    self.proc = cproc == "proc"
    self.public = cpublic == "public"
    return unless self.proc
    return unless ckind == "event"
      self.code[1..].each_with_index {|instruction, i| Instruction.create!(event: self, code: instruction, i: i)}
      self.instructions.sort.each {|instruction| instruction.proc_instruction }
  end
end