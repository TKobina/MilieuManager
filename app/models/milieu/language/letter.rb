class Letter < ApplicationRecord
  belongs_to :language

  def <=>(other)
    return self.sortkey <=> other.sortkey
  end

  def +(other)
    @letters = self.language.letters.order(sortkey: :asc)
    index = @letters.index(self)
    case other
    when Float then return self + other.to_i
    when Integer then rem = (other + index).divmod(self.language.letters.count).second
    when Letter then rem = (@letters.index(other) + index).divmod(self.language.letters.count).second
    end
    return @letters[rem] + 1 if @letters[rem].value.first == "h"
    @letters[rem]
  end

  def -(other)
    case other
    when Float then return self + (-1 * other.to_i)
    when Integer then return self + (-1 * other)
    when Letter
      @letters = self.language.letters.order(sortkey: :asc)
      index = @letters.index(self)
      return @letters[(index - @letters.index(other)).divmod(self.language.letters.count).second]
    end
  end
  
  def sortkind(other)
    kinds = {"vowel"=>1, "bridge"=>2, "consonant"=>3, "other"=>4}
    return -1 if kinds[self.kind] < kinds[other.kind]
    return 1 if kinds[self.kind] > kinds[other.kind]
    return self <=> other
  end
end
