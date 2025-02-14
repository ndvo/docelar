module UserProductivity
  extend ActiveSupport::Concern

  def navigation_params
    params.permit(
      :redirect_to
    )
  end
end
