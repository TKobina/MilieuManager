class Story < ApplicationRecord
  include Comparable
  belongs_to :milieu

  def <=>(other)
    self.chapter <=> other.chapter
  end
end
