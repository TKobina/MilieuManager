class Milieu < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  
  has_many :accesses, class_name: 'Access', foreign_key: :milieu_id, dependent: :destroy
  has_many :readers, through: :accesses, source: :reader
  
  has_many :ydates, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :properties, through: :entities
  
  has_many :languages, dependent: :destroy
  has_many :events, through: :ydates
  
  has_many :stories, dependent: :destroy

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

  def check_date

  end

  def proc_chronology
    self.entities.each {|ent| ent.properties.destroy_all}
    self.entities.destroy_all
    self.ydates.sort.each{|ydate| ydate.proc_ydate}
  end
end
