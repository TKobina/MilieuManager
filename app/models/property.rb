class Property < ApplicationRecord
  belongs_to :entity
  belogns_to :event
  
  validate :check_duplicate_property
  after_find :property_accessed
  
  def date
    @date
  end
  
  private

  def property_accessed
    if self.kind.include?("date")
      @date = Ydate.from_string(self.entity.milieu, self.value)
    end
  end

  def check_duplicate_property
    if self.entity.properties.map{|property| property.kind}.include?(self.kind)
      other = entity.properties.where(kind: self.kind).first
      if other
        other.value = self.value
        other.details = self.details if !self.details.nil?
        other.save  
        errors.add("", "#{self.entity.name} already has property #{self.kind}")
      end
    end
  end
end
