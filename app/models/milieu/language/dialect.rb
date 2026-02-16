class Dialect < ApplicationRecord
  belongs_to :entity
  belongs_to :language

  has_many :names, dependent: :destroy
  after_create_commit :get_base_abberations

  VARS = ["pattern", "vowel", "consonant", "bridge"]

  def get_base_abberations
    self.variances = self.language.get_vars(self)
    self.save
  end

  def generate_name
    @parent_dialect = self.entity.superiors.where(kind: ["house", "society", "nation"]).sample&.dialect
    @parent_dialect = self.language.entity.dialect if @parent_dialect.nil?
    pattern = self.language.patterns.find(self.generate_pattern).value

    name = ""
    pattern.each_char do |kind|
      while true
        case kind
        when 'v' then char = Letter.find(generate_letter("vowel")).value
        when 'b' then char = Letter.find(generate_letter("bridge")).value
        when 'c' then char = Letter.find(generate_letter("consonant")).value
        end
        break if char != name[-1]
        break if name.length == 1
      end
      name += char
    end
    name = name.capitalize
    self.names << Name.proc_name_society(name, self.entity, keep: true)
  end

  def generate_pattern
    if self.calc_abberation("pattern") == 1
      return random_pattern if @parent_dialect.nil?
      return @parent_dialect.generate_pattern unless @parent_dialect == self
    end
    patterns = build_pattern_distribution.max_by { |_, weight| rand ** (1.0 / weight) }
    return patterns.first unless patterns.nil?
    return random_pattern
  end

  def build_pattern_distribution
    patterns = self.occurrences["patterns"]
    sum = 0
    dist = {}
    patterns.each do |key, n|
      sum += n
      dist[key] = sum
    end
    dist
  end

  def generate_letter(kind)
    if self.calc_abberation(kind) == 1
      return random_letter(kind) if @parent_dialect.nil?    
      return @parent_dialect.generate_letter(kind) unless @parent_dialect == self
    end
    letters = build_letter_distribution(kind).max_by { |_, weight| rand ** (1.0 / weight) }
    return letters.first unless letters.nil?
    return random_letter(kind)
  end
  
  def build_letter_distribution(kind)
    sum = 0
    dist = {}
    self.occurrences["letters"][kind].each do |key, n|
      sum += n
      dist[key] = sum
    end
    dist
  end

  def random_letter(kind)
    self.language.letters.where(kind: kind).sample.id
  end

  def random_pattern
    plengths = self.language.patterns.map{|pattern| pattern.value.length}
    min = plengths.min
    max = plengths.max
    length = (min + (max + 1 - min) * (rand**2.5)).floor
    vpatterns = []
    self.language.patterns.find_each { |pattern| vpatterns << pattern if pattern.value.length == length }
    return vpatterns.sample.id
  end

  
  def stats?
    stats = {kinds: {}, letters: {}, patterns: {}, base_variations: {}}
    VARS.each do |var| 
      stats[:base_variations][var + "s"] = self.variances[var + "s"]
      stats[:kinds][var] = self.occurrences[var]
    end
    stats[:kinds]["pattern"] = self.occurrences["patterns"].keys.count

    ["vowel", "consonant", "bridge"].each do |kind|
      stats[:letters][kind] = {}
      values = self.occurrences["letters"][kind].values
      dist = calc_rel_freq(values)
      self.occurrences["letters"][kind].zip(dist).each do |ns, rs|
        stats[:letters][kind][ns.first] = [ns.second, rs]
      end
    end

    stats[:patterns] = {}
    values = self.occurrences["patterns"].values
    dist = calc_rel_freq(values)
    self.occurrences["patterns"].zip(dist).each do |ns, rs|
      stats[:patterns][ns.first] = [ns.second, rs]
    end
    stats
  end

  def calc_rel_freq(dist)
    values = []
    max = dist.max
    min = dist.min
    if max == 0
      values << 0*dist.count
      return values
    end
    dist.each do |value| 
      value = 0.00001 if value == 0
      min = max - 0.00001 if max == min
      value = 100*(value-min)/(max-min)
      value = value < 1 ? 0 : value
      values << value
    end
    values
  end

  def calc_abberation(kind) 
    n = self.occurrences["names"]
    var = self.variances[kind + "s"]
    n ||= 0
    return 1 if n.zero?
    prob = -1.132086 + 85.76358*Math::E**(-0.07854533*n) + var
    (rand*100 <= prob) ? 1 : 0
  end
end
