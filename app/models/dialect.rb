class Dialect < ApplicationRecord
  belongs_to :entity
  belongs_to :language

  has_many :frequencies, dependent: :destroy

  def generate_name
  
  end

  def self.proc_name(superior, entity)
    superior.dialect.proc_name(entity) if !superior.dialect.nil?
    superior.superiors.where(kind: ["House", "Nation"]).each {|susuperior| Dialect.proc_name(susuperior, entity) }
  end

  def proc_name(entity)
    name_pattern = ""

    self[:n_names] = self[:n_names].to_i + 1

    entity.name.each_char.with_index do |char, index|
      char = char.downcase
      next if char == "h" #not a "character" by itself
      char = "h" + char if [ "w", "r", "l", "y" ].include?(char) && entity.name[index-1] == "h"
      
      letter = self.language.letters.find { |letter| letter.letter == char }
      freq = letter.frequencies.find {|frequency| frequency.dialect == self }
      freq = Frequency.create!(letter: letter, dialect: self, kind: "letter") if freq.nil?
      freq.update!(n: freq.n.to_i + 1)

      ctype = self.language.get_type(char)
      name_pattern += ctype[0]
      ctype = "n_" + ctype + "s"
      self[ctype] = self[ctype].to_i + 1
    end
    
    pattern = Pattern.find_or_create_by!(pattern: name_pattern, language: self.language)
    freq = pattern.frequencies.find {|frequency| frequency.dialect == self }
    if freq.nil?
      freq = Frequency.create!(pattern: pattern, dialect: self, kind: "pattern")
      self.update!(n_patterns: self.n_patterns.to_i + 1)
    end
    freq.update!(n: freq.n.to_i + 1)
  end

  def stats?
    stats = {core: {}, letters: {}, patterns: {}}
    vars = Dialect.column_names.select { |name| name.start_with?('var') } 
    vars.each {|var| stats[:core][var] = self[var]}

    ns = Dialect.column_names.select { |name| name.start_with?('n_') } 
    ns.each {|n| stats[:core][n] = self[n]}

    #letters = self.language.letters
    lfreqs = self.frequencies.where(kind: "letter")
    lfreqs.each do |freq|
      stats[:letters][freq.letter.letter] = freq.n.to_i
    end
  
    pfreqs = self.frequencies.where(kind: "pattern")
    pfreqs.each do |freq|
      stats[:patterns][freq.pattern.pattern] = freq.n.to_i
    end

  stats
  end
end
