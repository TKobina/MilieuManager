class Language < ApplicationRecord
  include Comparable
  belongs_to :entity

  has_many :letters, dependent: :destroy
  has_many :dialects, dependent: :destroy
  has_many :lexemes, dependent: :destroy
  has_many :patterns, dependent: :destroy

  after_create_commit :proc_new_language

  MINNAMELEN = 3
  MAXNAMELEN = 7

  def proc_new_language
    set_alphabet
    set_patterns
    get_base_abberations
  end

  def get_type(char)
    self.letters.where(value: char).first.kind
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

      comp = self.letters.where(value: x).first <=> self.letters.where(value: y).first
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
    letters_present = self.letters.map{|letter| letter.value}
    alphabet.each do |kind, letters|
      letters.each do |key, value|        
          Letter.create!(language: self, kind: kind, value: key, sortkey: value) if !letters_present.include?(key)
      end
    end
  end

  def set_patterns
    def factorial(n) = n == 0 ? 1 : (1..n).inject(:*)

    progressbar = ProgressBar.create(title: "Generating patterns", total: 0.5*factorial(MAXNAMELEN) - factorial(MINNAMELEN))
    parts = [ "b", "c", "v" ]
    if Pattern.count < 500 
      (1 + MAXNAMELEN - MINNAMELEN).times do |i| 
        perms = parts.repeated_permutation(i + MINNAMELEN).to_a
        perms.each { |perm| check_pattern(perm.join); progressbar.increment }
      end
    end
    puts "Pattern generation complete"
  end
  
  def check_pattern(pattern)
    bridge = "b"
    return false if (pattern[0] == bridge) or (pattern[-1] == bridge)
    return false if /bb|ccc|bcc|ccb|cbb|cbc|bcc|bcb|vvv/.match?(pattern)
    return false if !self.patterns.where(value: pattern).first.nil?
    Pattern.create!(language: self, value: pattern)
  end

  def get_base_abberations
    paths = Rails.application.credentials.paths

    Rails.cache.write(self.id.to_s + "abberations", YAML.load_file(File.join(Rails.root, paths['abberations'])), expires_in: 2.hours)
  end

  def get_vars(society)
    Rails.cache.read(self.id.to_s + "abberations")[society.name]
  end
end
