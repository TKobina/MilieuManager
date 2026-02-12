class DialectsController < ApplicationController
  def index
    @language = @milieu.languages.find(params[:language_id])
    @stats = @language.stats?
    @dialects = @stats.keys
    @dialects.each do |dia| 
      @stats[dia][:rletters].keys.each {|key| @stats[dia][:rletters][key] = get_color(dia, @stats[dia][:rletters][key])}
      @stats[dia][:rpatterns].keys.each {|key| @stats[dia][:rpatterns][key] = get_color(dia, @stats[dia][:rpatterns][key])}
    end
  end

  def show
    @columns = {}
    @columns[:core] =  @stats.values.map{|value| value[:core].keys}.flatten.uniq
    @columns[:letters] = language.letters.map{|letter| letter.value }
    patterns = @stats.values.map{|value| value[:patterns].keys}.flatten.uniq.sort_by {|s| [s.length, s]}
    
    @columns[:patterns] = patterns
  end

  def get_color(society, value)
    value = value / 100.0
    case society[-2..-1]
    when "-w" then return w_color(value)
    when "-n" then return n_color(value)
    when "-m" then return m_color(value)
    else
      return color(value)
    end
  end

  def w_color(value)
    rgb1 = [43,2,44]
    rgb2 = [254, 158, 255]
    interpol(rgb1, rgb2, value)
  end
  
  def n_color(value)
    rgb1 = [    0, 27, 57]
    rgb2 = [    129, 174, 240]
    interpol(rgb1, rgb2, value)
  end
  
  def m_color(value)
    rgb1 = [ 0, 49, 0]
    rgb2 = [174, 252, 174]
    interpol(rgb1, rgb2, value)
  end

  def color(value)
    rgb1 = [50, 8, 6]
    rgb2 = [230, 202, 94]
    interpol(rgb1, rgb2, value)
  end

  def interpol(rgb1, rgb2, percent)
    #ResultRed = R1 + percent * (R2 - R1)
    #ResultGreen = G1 + percent * (G2 - G1)
    #ResultBlue = B1 + percent * (B2 - B1)
    r = rgb1[0] + percent*(rgb2[0]-rgb1[0])
    g = rgb1[1] + percent*(rgb2[1]-rgb1[1])
    b = rgb1[2] + percent*(rgb2[2]-rgb1[2])
    a = 0.4
    #"td[data-value="0"] { background-color: rgb(38,151,47,0.4); }"
    rgb = "rgb(" + r.ceil.to_s + "," + g.ceil.to_s + "," + b.ceil.to_s + "," + a.to_s + ")"
    rgb
  end
end
