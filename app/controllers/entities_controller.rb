class EntitiesController < ApplicationController
  def index
    set_privacy
    @entities = filter_entities(@milieu.entities).where.not(kind: "world").sort
  end

  def show
    set_privacy
    @entity = @milieu.entities.find(params[:id])

    if (!@private && !@entity.public)
      redirect_to entities_path(current_milieu: @milieu), alert: "Not authorized or record not found."
    end

    @superiors, @superior_relations = filter_relations(@entity.superiors, @entity.superior_relations)
    @inferiors, @inferior_relations = filter_relations(@entity.inferiors, @entity.inferior_relations)
    @events = filter_events(@entity.events)

    @text_public = @entity.text["pub"]
    @text_private = @private ? @entity.text["pri"] : ""

  end

  #<%= @entity.text["pri"] %></p>
  #<%= @entity.text["pub"] %></p>

  private

  def set_privacy
    @private = true if @milieu.owner == current_user
    @private = @private ? true : @milieu.accesses.where(reader: current_user).first.private_rights
  end

  def filter_entities(entities)
    @private ? entities : entities.where(public: true)
  end

  def filter_relations(entities, relations)
    visible = [[],[]]
    if @private
      visible[0] = entities
      visible[1] = relations
    else
      entities.zip(relations).each do |ent, rel|
        next unless ent.public
        visible.first << ent
        visible.second << rel
      end
    end
    visible
  end

  def filter_events(events)
    @private ? events : events.where(public: true)
  end
end
