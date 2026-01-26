class Relation < ApplicationRecord
  belongs_to :superior, class_name: "Entity"
  belongs_to :inferior, class_name: "Entity"
end
