class Reference < ApplicationRecord
  belongs_to :milieu
  has_one :entity

  before_save :init
  def <=>(other)
    return self.entity<=>other.entity if self.entity && other.entity
    selfname = self.name || self.entity.name
    othername = other.name || other.entity.name
    Language.first.sort(selfname, othername)
  end

  def pri? = self.text[:pri]
  def pub? = self.text[:pub]
  def pri(text)
    self.text[:pri] = text
    self.save
  end
  def pub(text)
    self.text[:pri] = text
    self.save
  end

  def init
    self.text = {pri: "", pub: ""} if self.text.nil?
  end
end
