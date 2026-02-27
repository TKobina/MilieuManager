class Relclass < ApplicationRecord
  belongs_to :milieu
  has_many :relclasses
  
  validates :kind, uniqueness: { scope: :milieu_id, message: "You have already created a Relation Class with this value." }

end
