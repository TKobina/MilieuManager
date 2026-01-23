class Language < ApplicationRecord
  belongs_to :milieu

  has_many :letters, dependent: :destroy
  has_many :dialects, dependent: :destroy
  has_many :lexemes, dependent: :destroy
  has_many :patterns, dependent: :destroy

end
