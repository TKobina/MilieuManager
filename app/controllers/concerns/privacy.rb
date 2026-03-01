module Privacy
  extend ActiveSupport::Concern

  def get_milieu
    return unless current_user.present?
    @milieu = current_user.milieus.where(id: params[:current_milieu]).first || current_user.readings.where(id: params[:current_milieu]).first
    return unless @milieu.present?
    @owner = @milieu.owner == current_user
    set_privacy
  end

  def set_privacy
    return unless @milieu.present?
    @private = true if @milieu.owner == current_user
    @private = @private ? true : @milieu.accesses.where(reader: current_user).first.private_rights
  end

  def filter_records(records)
    @private ? records : records.where(public: true)
  end

  def filter_joint_records(records, joints)
    visible = [[],[]]
    if @private
      visible[0] = records
      visible[1] = joints
    else
      records.zip(joints).sort_by { |pair| pair[0] }.each do |rec, joi|
        next unless rec.public
        visible.first << rec
        visible.second << joi
      end
    end
    visible
  end

  def cache_records(model, records)
    @sorted_records = Rails.cache.fetch([model + "_key", records.maximum(:updated_at), records.count], expires_in: 24.hour) do
      records.sort
    end
  end
end