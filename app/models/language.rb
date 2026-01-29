class Language < ApplicationRecord
  include Comparable
  belongs_to :entity

  has_many :letters, dependent: :destroy
  has_many :dialects, dependent: :destroy
  has_many :lexemes, dependent: :destroy
  has_many :patterns, dependent: :destroy

  after_create_commit :proc_new_language

  def proc_new_language
    set_alphabet
    set_patterns
  end

  def get_type(char)
    self.letters.where(letter: char).first.kind
  end
  
  def sort(xword, yword)
    return -1 if  xword.nil? && !yword.nil?
    return 0  if  xword.nil? &&  yword.nil?
    return 1  if !xword.nil? &&  yword.nil?
    
    xword = xword.downcase.chars.reject {|char| char == "h"}
    yword = yword.downcase.chars.reject {|char| char == "h"}

    xword.zip(yword).each do |x, y|
      return -1 if  x.nil? && !y.nil?
      return 0  if  x.nil? &&  y.nil?
      return 1  if !x.nil? &&  y.nil?

      comp = self.letters.where(letter: x).first <=> self.letters.where(letter: y).first
      return comp if comp!= 0
    end
    0
  end

  def stats?
    stats = {}
    self.dialects.each { |dialect| stats[dialect.name] = dialect.stats?}
    stats
  end
  
  def set_alphabet
    paths = Rails.application.credentials.paths

    alphabet = YAML.load_file(File.join(Rails.root, paths['alphabet']))
    letters_present = self.letters.map{|letter| letter.letter}
    alphabet.each do |kind, letters|
      letters.each do |key, value|
        if !letters_present.include?(key)
          Letter.create!(language: self, kind: kind, letter: key, sortkey: value)
        end
      end
    end
  end

  def set_patterns
    puts "Generating patterns"

    parts = [ "b", "c", "v" ]
    if Pattern.count < 500 
      6.times do |i| 
        perms = parts.repeated_permutation(i + 3).to_a
        perms.each do |perm|
          pattern = Pattern.create(language: self, pattern: perm.join)
          if !pattern.save
            #puts "Pattern failed validation: #{pattern.errors.full_messages.join(', ')}"
          end
        end
      end
    end
  end
end
