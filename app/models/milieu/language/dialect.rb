class Dialect < ApplicationRecord
  belongs_to :entity
  belongs_to :language

  has_many :names, dependent: :destroy

  def stats?
    stats = {core: {}, letters: {}, rletters: {}, patterns: {}, rpatterns: {}}
    vars = Dialect.column_names.select { |name| name.start_with?('var') } 
    vars.each {|var| stats[:core][var] = self[var]}

    ns = Dialect.column_names.select { |name| name.start_with?('n_') } 
    ns.each {|n| stats[:core][n] = self[n]}

    #  ["vowel", "consonant", "bridge"].each do |kind|
    #   kfreqs = {}    
    #   lfreqs = self.frequencies.where(kind: kind)
    #   lfreqs.each do |freq|
    #     kfreqs[freq.letter.value] = freq.n.to_i
    #     stats[:letters][freq.letter.value] = freq.n.to_i
    #   end
    #   rel_freqs = calc_rel_freq(kfreqs.values)
    #   kfreqs.keys.zip(rel_freqs) {|key, relfreq| stats[:rletters][key] = relfreq}
    # end
  
    # pfreqs = self.frequencies.where(kind: "pattern")
    # pfreqs.each do |freq|
    #   stats[:patterns][freq.pattern.value] = freq.n.to_i
    # end
    # rel_freqs = calc_rel_freq(stats[:patterns].values)
    # stats[:patterns].keys.zip(rel_freqs) {|key, relfreq| stats[:rpatterns][key] = relfreq}

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

  def generate_name
    @parents = self.entity.superiors
    @parent_dialect = @parents.empty? ? nil : @parents.sample.dialect 
    pattern = generate_pattern

    name = ""
    pattern.each_char do |kind|
      while true
        case kind
        when 'v' then char = generate_letter("vowel")
        when 'b' then char = generate_letter("bridge")
        when 'c' then char = generate_letter("consonant")
        end
        break if char != name[-1]
        break if name.length == 1
      end
      name += char
    end
    name = name.capitalize
    
    Name.create!(dialect: self, value: name)
    self.proc_name(name)
  end

  def generate_letter(kind)
    if Dialect.calc_abberation(self.n_names) == 1
      return @parent_dialect.generate_letter(kind) unless @parent_dialect.nil?
      return random_letter(kind)      
    end
    letter = build_letter_distribution(kind).max_by { |_, weight| rand ** (1.0 / weight) }
    return letter.first unless letter.nil?
    return random_letter(kind)
  end
  
  def build_letter_distribution(kind)
    sum = 0
    dist = {}
    self.frequencies.where(kind: kind).each do |freq|
      sum += freq.n
      dist[freq.letter.value] = sum
    end
    dist
  end

  def generate_pattern
    if Dialect.calc_abberation(self.frequencies.where(kind: "pattern").count) == 1
      return @parent_dialect.generate_pattern unless @parent_dialect.nil?
      return random_pattern      
    end
    pattern = build_pattern_distribution.max_by { |_, weight| rand ** (1.0 / weight) }
    return pattern.first unless pattern.nil?
    return random_pattern
  end

  def build_pattern_distribution
    patterns = self.frequencies.where(kind: "pattern")
    sum = 0
    dist = {}
    patterns.each do |pattern|
      sum += pattern.n
      dist[pattern.pattern.value] = sum
    end
    dist
  end

  def random_letter(kind)
    self.language.letters.where(kind: kind).sample.value
  end

  def random_pattern
    plengths = self.language.patterns.map{|pattern| pattern.value.length}
    min = plengths.min
    max = plengths.max
    length = (min + (max + 1 - min) * (rand**2.5)).floor
    vpatterns = []
    self.language.patterns.find_each { |pattern| vpatterns << pattern if pattern.value.length == length }
    return vpatterns.sample.value
  end

  def self.calc_abberation(n) 
    n ||= 0
    return 1 if n.zero?
    prob = -1.132086 + 85.76358*Math::E**(-0.07854533*n)
    (rand*100 <= prob) ? 1 : 0
  end
end
