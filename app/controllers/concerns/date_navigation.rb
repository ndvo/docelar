module DateNavigation
  extend ActiveSupport::Concern

  def set_month_navigation
    str_date = date_navigation_params['date']
    today = str_date.nil? ? Date.today : Date.parse(str_date)
    @chosen_month ||= today.change(day: 1)
    @previous_month = @chosen_month - 1.month
    @next_month = @chosen_month + 1.month
  end

  def date_navigation_params
    params.permit(:date)
  end
end
