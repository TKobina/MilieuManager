module Currency
  extend ActiveSupport::Concern

  def milieu? 
    @current_milieu if @current_milieu.user == current_user
  end
  def current_milieu(milieu) 
    @current_milieu = milieu
  end
  def language?
    @current_language if @current_language.entity.milieu == @current_milieu
  end
  def current_language(language) 
    @current_language = language
  end
end