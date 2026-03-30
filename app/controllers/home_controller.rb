class HomeController < ApplicationController
  def index
    @tasks_today_count = Task.pending.count
    @payments_due_count = Payment.pending.where("due_at <= ? AND due_at >= ?", Date.today + 7.days, Date.today).count
    @pets_count = Dog.count
    @recent_photos_count = Photo.count

    @upcoming_tasks = Task.pending.order(created_at: :desc).limit(5)
  end
end
