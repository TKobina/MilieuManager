class LexemesController < ApplicationController
  #before_action :check_user#, only: [:show, :edit, :update, :destroy]

  def index
    language = Language.find(params[:language_id])
    @lexemes = language.lexemes.sort if current_user.languages.include?(language) 
  end

  def show
    lexeme = Lexeme.find(params[:id])
    @lexeme = lexeme if lexeme.language.entity.milieu.user == current_user
  end

  private

  def check_user
    
  end
end
