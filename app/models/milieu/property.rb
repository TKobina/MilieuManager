class Property < ApplicationRecord
  belongs_to :entity

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
end
