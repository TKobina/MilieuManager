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
  
  def self.to_csv
    attributes = %w{language_id word eid kind meaning details} # Replace with your actual column names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |lexeme|
        csv << attributes.map{ |attr| lexeme.send(attr) }
      end
    end
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
