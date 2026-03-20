class Lexeme < ApplicationRecord
  include Comparable

  require 'csv'
  
  belongs_to :language

  has_many :sublexeme_compositions, class_name: "Composition", foreign_key: "suplexeme_id", dependent: :destroy
  has_many :sublexemes, through: :sublexeme_compositions, source: :sublexeme

  has_many :suplexeme_compositions, class_name: "Composition", foreign_key: "sublexeme_id"
  has_many :suplexemes, through: :suplexeme_compositions, source: :suplexeme

  validates :eid, uniqueness: { scope: :language_id, message: "You have already created a lexeme with this eid." }


  after_create_commit :proc_new_lexeme

  def <=>(other)
    self.language.sort(self.word, other.word)
  end

  def procsubs(eids)
    self.sublexeme_ids = eids.split(",").map{|eid| self.language.lexemes.where(eid: eid.strip()).first.id}
    self.save
  end

  private

  def proc_new_lexeme
    self.update!(eid: self.language.fetch_maxlexeid) if self.eid.nil?
  end
end
