class Letter < ApplicationRecord
  belongs_to :language

  has_many :frequencies, dependent: :destroy

  def <=>(other)
    return self.sortkey <=> other.sortkey
  end
  
  def sortkind(other)
    kinds = {"vowel"=>1, "bridge"=>2, "consonant"=>3, "other"=>4}
    return -1 if kinds[self.kind] < kinds[other.kind]
    return 1 if kinds[self.kind] > kinds[other.kind]
    return self <=> other
  end
end
