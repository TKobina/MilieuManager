class Property < ApplicationRecord
  belongs_to :entity
  
  validate :check_duplicate_property
  after_find :property_accessed
  
  def date
    @date
  end
  private
  def property_accessed
    if self.kind.include?("date")
      @date = Ydate.find(self.value.to_i)
    end
  end

  def check_duplicate_property
    if self.entity.properties.map{|property| property.name}.include?(self.kind)
      other = entity.properties.where(kind: self.kind).first
      other.value = self.value
      other.details = self.details if !self.details.nil?
      other.save  
      errors.add("", "#{self.entity.name} already has property #{self.kind}")
    end
  end
end
