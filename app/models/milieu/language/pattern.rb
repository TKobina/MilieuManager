class Pattern < ApplicationRecord
  belongs_to :language
  #validate :check_pattern
  
  # Don't start or end on a b
  # cc must have vowel on either side
  # cb must be followed by a vowel
  # bc must be led by a vowel
  # never more than 1 consecutive bridge

  def <=>(other)
    if self.value.length != other.value.length
      self.value.length <=> other.value.length
    end
    self.value <=> other.value
  end
end