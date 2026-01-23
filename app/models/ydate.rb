class Ydate < ApplicationRecord
  has_many :events
  belongs_to :milieu

  DAYS_MONTH = 24
  DAYS_SEASON = 4 * DAYS_MONTH
  DAYS_YEAR = 4 * DAYS_SEASON

  def to_s
    return "" if self.date.nil?
    year, r = self.date.divmod(DAYS_YEAR)
    season, r = r.divmod(DAYS_SEASON)
    month, day = r.divmod(DAYS_MONTH)

   [year, season, month, day].map{ |val| (val += 1).to_s }.join(".")
  end

  def self.from_days(milieu, intdate)
    ydate = Ydate.find_by(milieu: Milieu.first, date: intdate)
    ydate.nil? ? create!(milieu: milieu, date: intdate) : ydate
  end

  def self.from_string(milieu, strdate)
    year, season, month, day = strdate.split(".").map! { |s| (s.to_i - 1) }
    days = (year * DAYS_YEAR) + (season * DAYS_SEASON) + (month * DAYS_MONTH) + day
    ydate = Ydate.find_by(milieu: Milieu.first, date: days)

    ydate.nil? ? create!(milieu: milieu, date: days) : ydate
  end

  def self.random(milieu, year: 0)
    year = Random.new.rand(0...500) if year == 0
    season = Random.new.rand(1...4)
    month = Random.new.rand(1...4)
    day = Random.new.rand(1...24)
    days = (year * DAYS_YEAR) + (season * DAYS_SEASON) + (month * DAYS_MONTH) + day
    ydate = Ydate.find_by(milieu: Milieu.first, date: days)

    ydate.nil? ? create!(milieu: milieu, date: days) : ydate
  end

  private
end

