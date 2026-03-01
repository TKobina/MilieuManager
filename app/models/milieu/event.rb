class Event < ApplicationRecord
  belongs_to :milieu
  belongs_to :ydate
  
  has_many :properties, dependent: :destroy
  has_many :relations, dependent: :destroy
  has_and_belongs_to_many :entities
  has_many :children, class_name: 'Entity', foreign_key: :genvent_id, dependent: :destroy
  has_many :instructions, dependent: :destroy
  accepts_nested_attributes_for :instructions, allow_destroy: true

  validates :name, uniqueness: { scope: :milieu_id, message: "You have already created an event with name" }

  after_commit :gen_instructions

  def date? = self.ydate.to_s
  def <=>(other) = self.ydate == other.ydate ? self.i <=> other.i : self.ydate <=> other.ydate

  def gen_instructions
    return unless saved_change_to_proc? || saved_change_to_code?
    self.instructions.destroy_all
    self.code.each_with_index do |instruction, i|
      Instruction.create!(event: self, code: instruction, i: i)
    end
  end

  def proc_event
    self.instructions.sort.each {|instruction| instruction.proc_instruction } if self.proc
  end
end