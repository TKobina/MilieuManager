class DialectsController < ApplicationController
  def index
    language = Language.find(params[:language_id])
    language = language.entity.milieu.user == current_user ? language : nil
    @stats = language.stats?
    @dialects = @stats.keys

    @columns = {}
    @columns[:core] =  @stats.values.map{|value| value[:core].keys}.flatten.uniq
    @columns[:letters] = language.letters.map{|letter| letter.letter }
    @columns[:patterns] = @stats.values.map{|value| value[:patterns].keys}.flatten.uniq
    
  end
end
