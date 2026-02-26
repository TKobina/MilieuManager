class Ydate < ApplicationRecord
  has_many :events, dependent: :destroy
  belongs_to :milieu

  validates :value, uniqueness: { scope: :language_id, message: "You have already created a letter with this value." }

  

  DAYS_MONTH = 24
  DAYS_SEASON = 4 * DAYS_MONTH
  DAYS_YEAR = 4 * DAYS_SEASON

  def <=>(other) = self.value <=> other.value

  def proc_ydate
    self.events.sort.each{|event| event.proc_event }
  end

  def to_s
    return "" if self.value.nil?
    year, r = self.value.divmod(DAYS_YEAR)
    season, r = r.divmod(DAYS_SEASON)
    month, day = r.divmod(DAYS_MONTH)

    [year, season, month, day].map{ |val| (val += 1).to_s }.join(".")
  end

  def self.to_str(intdate)
    return "" if intdate.nil?
    year, r = intdate.divmod(DAYS_YEAR)
    season, r = r.divmod(DAYS_SEASON)
    month, day = r.divmod(DAYS_MONTH)

    [year, season, month, day].map{ |val| (val += 1).to_s }.join(".")
  end

  def self.from_days(milieu, intdate)
    ydate = Ydate.find_by(milieu: Milieu.first, value: intdate)
    ydate.nil? ? create!(milieu: milieu, value: intdate) : ydate
  end

  def self.from_string(milieu, strdate)
    year, season, month, day = strdate.split(".").map! { |s| (s.to_i - 1) }
    days = (year * DAYS_YEAR) + (season * DAYS_SEASON) + (month * DAYS_MONTH) + day
    ydate = Ydate.find_by(milieu: Milieu.first, value: days)

    ydate.nil? ? create!(milieu: milieu, value: days) : ydate
  end

  def self.random(milieu, year: 0)
    year = Random.new.rand(0...500) if year == 0
    season = Random.new.rand(1...4)
    month = Random.new.rand(1...4)
    day = Random.new.rand(1...24)
    days = (year * DAYS_YEAR) + (season * DAYS_SEASON) + (month * DAYS_MONTH) + day
    ydate = Ydate.find_by(milieu: Milieu.first, value: days)

    ydate.nil? ? Ydate.new(milieu: milieu, value: days) : ydate
  end

  private
end
