class Admin::GroveMonitorController < ApplicationController
  def show
    @students = current_user.grove.students.send(filter_params)
    authorize(:teacher_resource, :show?)
  end

  private

    def filter_params
      params[:filter] || :all
    end
end
