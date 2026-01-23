class Letter < ApplicationRecord
  belongs_to :language

  def <=>(other)
    self.sortkey <=> other.sortkey
  end
end
