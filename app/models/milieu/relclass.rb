class Relclass < ApplicationRecord
  belongs_to :milieu
  has_many :relclasses
  
end
