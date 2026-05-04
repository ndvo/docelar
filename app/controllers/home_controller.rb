class HomeController < ApplicationController
  include ActionView::Helpers::NumberHelper
  helper_method :time_ago_in_words
  
  def index
    # Quick stats for status bar
    @tasks_pending = Task.pending.count
    @payments_due = Payment.pending.where("due_at <= ?", Date.today + 7.days).count
    @pets_count = Dog.count
    @photos_count = Photo.count
    @videos_count = Video.count

    # Upcoming tasks for dashboard widget
    @upcoming_tasks = Task.pending.order(created_at: :desc).limit(5)

    # Module status (for module cards)
    @implemented_modules = {
      finance: %w[cards purchases payments products],
      health: %w[patients treatments pharmacotherapies medications people],
      pets: %w[dogs],
      productivity: %w[tasks notes tags],
      media: %w[galleries photos articles videos],
      calendar: true
    }

    # Recent activity (simplified for now)
    @recent_activity = build_recent_activity
  end

  private

  def build_recent_activity
    activity = []

    # Recent payments
    Payment.order(created_at: :desc).limit(3).each do |payment|
      activity << {
        icon: "payment",
        text: "Payment: #{payment.purchase&.merchant || payment.purchase&.product&.name} - #{number_to_currency(payment.due_amount)}",
        time: time_ago_in_words(payment.created_at)
      }
    end

    # Recent tasks
    Task.order(created_at: :desc).limit(3).each do |task|
      activity << {
        icon: "task",
        text: "Task: #{task.name}",
        time: time_ago_in_words(task.created_at)
      }
    end

    activity.sort_by { |a| a[:time] }.first(5)
  end

  def time_ago_in_words(from_time)
    seconds = Time.current - from_time
    
    case seconds
    when 0..59
      "agora"
    when 60..3599
      minutes = (seconds / 60).floor
      "#{minutes} #{'minuto'.pluralize(minutes)} atrás"
    when 3600..86399
      hours = (seconds / 3600).floor
      "#{hours} #{'hora'.pluralize(hours)} atrás"
    when 86400..604799
      days = (seconds / 86400).floor
      "#{days} #{'dia'.pluralize(days)} atrás"
    else
      weeks = (seconds / 604800).floor
      "#{weeks} #{'semana'.pluralize(weeks)} atrás"
    end
  end
end
