class Relation < ApplicationRecord
  belongs_to :superior, class_name: "Entity",  foreign_key: "superior_id"
  has_one :inferior, class_name: "Entity", foreign_key: "inferior_id"
  belongs_to :event
end
