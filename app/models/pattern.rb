class Pattern < ApplicationRecord
  belongs_to :language
  validate :check_pattern

  has_many :frequencies
  
  private
  
  # Don't start or end on a b
  # cc must have vowel on either side
  # cb must be followed by a vowel
  # bc must be led by a vowel
  # never more than 1 consecutive bridge
  def check_pattern
    bridge = "b"
    if (pattern[0] == bridge) or (pattern[-1] == bridge)
      errors.add("", "#{self.pattern} must not start or end with #{bridge}")
    elsif /ccc|bcc|ccb|cbb|cbc|bcc|bcb|vvv|bb/.match?(pattern)
      errors.add("", "#{self.pattern} is an invalid pattern")
    elsif !Pattern.where(language: self.language, pattern: pattern).first.nil?
      errors.add("", "#{self.pattern} already present in #{self.language.name}")
    end
  end
end