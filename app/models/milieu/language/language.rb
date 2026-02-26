class Language < ApplicationRecord
  include Comparable
  belongs_to :nation, class_name: 'Entity', foreign_key: 'nation_id'

  belongs_to :milieu

  has_many :letters, dependent: :destroy
  has_many :dialects, dependent: :destroy
  has_many :lexemes, dependent: :destroy
  has_many :patterns, dependent: :destroy
  has_many :entities

  after_create_commit :proc_new_language

  MINNAMELEN = 3
  MAXNAMELEN = 7
  #ALPHABETPATH = File.join(Rails.root, Rails.application.credentials.paths['alphabet'])
  #ABBERATIONPATH = File.join(Rails.root, Rails.application.credentials.paths['abberations'])
  INVALIDPATTERN = /\A[b]|bb|ccc|bcc|ccb|cbb|cbc|bcc|bcb|vvv|[b]\z/

  def proc_new_language
    set_alphabet
    set_patterns
    get_base_abberations
  end

  def get_type(char)
    self.letters.where(value: char).first.kind
  end

  def fetch_maxlexeid
    #p "#{id} | #{self.maxlexeid}"
    id = self.maxlexeid
    self.update!(maxlexeid: self.incr(self.maxlexeid))
    id
  end

  def incr(string)
    revletters = string.split('').map{|letter| self.letters.where(value: letter).first}.reverse
    incarr = []
    carried = true
    revletters.each do |letter|
      if carried
        incarr << letter + 1
        carry = incarr.last <=> letter
        carried = carry==-1 ? true : false
      else
        incarr << letter
      end
    end
    incarr << incarr.last + 1 if carried
    incarr.reverse.map{|letter| letter.value}.join("")
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
    alphabet = YAML.load_file(File.join(Rails.root, Rails.application.credentials.paths['alphabet']))
    letters_present = self.letters.map{|letter| letter.value}
    alphabet.each do |kind, letters|
      letters.each do |key, value|        
          Letter.create!(language: self, kind: kind, value: key, sortkey: value) if !letters_present.include?(key)
      end
    end
    self.update!(maxlexeid: self.letters.order(sortkey: :asc).first.value)
  end

  def set_patterns
    def factorial(n) = n == 0 ? 1 : (1..n).inject(:*)

    progressbar = ProgressBar.create(title: "Generating patterns", total: factorial(MAXNAMELEN) - factorial(MINNAMELEN))
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
    return false if INVALIDPATTERN.match?(pattern)
    return false if !self.patterns.where(value: pattern).first.nil?
    Pattern.create!(language: self, value: pattern)
  end

  def get_base_abberations
    paths = Rails.application.credentials.paths

    Rails.cache.write(self.id.to_s + "abberations", YAML.load_file(File.join(Rails.root, Rails.application.credentials.paths['abberations'])), expires_in: 2.hours)
  end

  def get_vars(society)
    Rails.cache.read(self.id.to_s + "abberations")[society.name]
  end
end
