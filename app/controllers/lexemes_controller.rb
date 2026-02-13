class LexemesController < ApplicationController
  def index
    @lexemes = @milieu.languages.find(params[:language_id]).lexemes.sort

    respond_to do |format|
      format.html
      format.csv { send_data @lexemes.to_csv, filename: "lexemes-#{Date.today}.csv" }
    end
  end

  def show
    @lexeme = Lexeme.find(params[:id])

    if (@lexeme.language.entity.milieu.owner != current_user && !@lexeme.language.entity.milieu.readers.include?(current_user))
      redirect_to lexemes_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

  end

  def new
    @lexeme = Lexeme.new
  end

  def create
    @lexeme = Lexeme.new(lexeme_params)
    @story.language = params[:language_id]
    if @lexeme.save
      redirect_to @lexeme
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    #@story = @milieu.stories.find(params[:id])
  end

  def update
    #@story = @milieu.stories.find(params[:id])
    #if @story.update(story_params)
    #  redirect_to @story
    #else
    #  render :edit, status: :unprocessable_entity
    #end
  end

  def destroy
    #@story = @milieu.stories.find(params[:id])
    #@story.destroy
    #redirect_to stories_path
  end


  private
    def lexeme_params
      params.expect(lexeme: [ :word, :kind, :meaning ])
    end
end

    # @event = @milieu.events.find(params[:id])
    # if (!@private && !@event.public)
    #   redirect_to events_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    # end