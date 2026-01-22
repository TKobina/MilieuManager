class Dialect < ApplicationRecord
  belongs_to :entity
  belongs_to :language

  has_many :frequencies
end
