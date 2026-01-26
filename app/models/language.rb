class Language < ApplicationRecord
  belongs_to :entity

  has_many :letters, dependent: :destroy
  has_many :dialects, dependent: :destroy
  has_many :lexemes, dependent: :destroy
  has_many :patterns, dependent: :destroy

end
