class Encylofile < ApplicationRecord
  belongs_to :encyclofolder
  has_many :encyclofolders, dependent: :destroy
end
