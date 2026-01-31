class Composition < ApplicationRecord
  belongs_to :language
  has_and_belongs_to_many :lexemes
end
