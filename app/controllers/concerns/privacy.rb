module Privacy
  extend ActiveSupport::Concern

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
        records.zip(joints).each do |rec, joi|
          next unless ent.public
          visible.first << rec
          visible.second << joi
        end
      end
      visible
    end

  # def milieu? 
  #   @current_milieu if @current_milieu.user == current_user
  # end
  # def current_milieu(milieu) 
  #   @current_milieu = milieu
  # end
  # def language?
  #   @current_language if @current_language.entity.milieu == @current_milieu
  # end
  # def current_language(language) 
  #   @current_language = language
  # end
end