class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  
  has_and_belongs_to_many :entities

  has_many :instructions, dependent: :destroy
  accepts_nested_attributes_for :instructions, allow_destroy: true

  before_save :proc_code
  after_commit :gen_instructions

  def date? = self.ydate.to_s
  def <=>(other) = self.ydate == other.ydate ? self.i <=> other.i : self.ydate <=> other.ydate

  def proc_code
    self.code = self.code.split("\n")
    cproc, ckind, cpublic = self.code&.first&.split("|").map{|x| x.strip}
    self.proc = cproc == "proc"
    #self.kind = ckind
    self.public = cpublic == "public"
  end

  def gen_instructions
    return unless saved_change_to_code?
    self.instructions.destroy_all
    self.code[1..].each_with_index do |instruction, i| 
      instruction = instruction.split("|").map{|x| x.strip}.join("|")
      Instruction.create!(event: self, code: instruction, i: i)
    end
  end

  def proc_event
    self.instructions.sort.each {|instruction| instruction.proc_instruction } if self.proc
  end
end