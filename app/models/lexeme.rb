class Lexeme < ApplicationRecord
  include Comparable
  belongs_to :language

  has_and_belongs_to_many :compositions, dependent: :destroy

  accepts_nested_attributes_for :compositions

  def <=>(other)
    #LEDLANG.sort(self.word, other.word)
    return 0
  end
end
