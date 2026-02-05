class Milieu < ApplicationRecord
  belongs_to :user
  
  has_many :ydates, dependent: :destroy
  has_one :encyclopedium, dependent: :destroy
  
  has_many :entities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :languages, through: :entities
  #has_many :stories, dependent: :destroy

  def get_date_from_strdate(strdate)
    Ydate.from_string(self, strdate)
  end

  def get_date_from_intdate(intdate)
    Ydate.from_days(self, intdate)
  end

  def get_date_random(year: 0)
    Ydate.random(self, year: year)
  end

  def from_user(user)
    self.where(user: current_user)
  end
end
