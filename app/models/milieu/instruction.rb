class Instruction < ApplicationRecord
  belongs_to :event

  after_create_commit :parse

  KINDS = {
  "formation": :formation,
  "founding": :founding,
  "birth": :birth,
  "death": :death,
  "adoption": :adoption,
  "exiling": :exiling,
  "raising": :raising,
  "claiming": :claiming,
  "disclaiming": :disclaiming,
  "hiring": :hiring,
  "firing": :firing,
  "status_change": :status_change,
  "special": :special}

  def parse
    self.kind = self.code.split("|").first
    self.save
  end

  def proc
    send(KINDS.fetch(self.kind.to_sym, :special))
  end

  def formation
    Entity.new(events: [self.event]).formation(self.code)
  end

  def founding
    Entity.new(events: [self.event]).founding(self.code)
  end

  def birth
    Entity.new(events: [self.event]).birth(self.code)
  end

  def death
    #Entity.fetch(kind, self, self.code[index]).death(self, self.code[index])
  end

  def adoption
    #Entity.fetch(kind, self, self.code[index]).adoption(self, self.code[index])
  end

  def exiling
  end

  def raising
  end

  def claiming
  end

  def disclaiming
  end

  def hiring
  end

  def firing
  end

  def status_change
    
  end

  def special
    
  end

end
