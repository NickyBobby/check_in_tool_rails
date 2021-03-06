class Admin::ActivitiesController < Admin::ResourceController
  def new
    @locations = Location.where(grove_id: current_user.grove_id)
    super
  end

  def create
    super do |activity|
      activity.grove = current_user.grove
    end
  end

  def edit
    @locations = Location.where(grove_id: current_user.grove_id)
    super
  end

  private

    def collection
      Activity.for_user(current_user)
    end

    def collection_attributes
      [:name, :location_name]
    end

    def form_attributes
      [:name, :image]
    end

    def whitelist
      [:name, :image, :location_id]
    end

    def after_save_path_for(resource)
      admin_activities_path
    end
end
