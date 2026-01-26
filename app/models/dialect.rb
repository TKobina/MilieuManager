class Dialect < ApplicationRecord
  belongs_to :entity
  belongs_to :language

  has_many :frequencies, dependent: :destroy

  def generate_name
  
  end
end
