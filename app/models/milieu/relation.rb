class Relation < ApplicationRecord
  belongs_to :superior, class_name: "Entity"
  belongs_to :inferior, class_name: "Entity"
  belongs_to :event

  def <=>(other)
    self.event.ydate.value <=> other.event.ydate.value
  end
end
