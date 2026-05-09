class TaskSessionsController < ApplicationController
  before_action :require_authentication

  def start
    @task = current_user.tasks.find(params[:task_id])

    if @task.task_log_entries.where(status: :in_progress).exists?
      redirect_back(fallback_location: tasks_path, alert: "Task already in progress.")
      return
    end

    # Create or find today's task log
    task_log = current_user.task_logs.find_or_create_for_today
    task_log.update(status: :active) if task_log.draft?

    # Create or update task log entry
    entry = task_log.task_log_entries.find_or_create_by(task: @task) do |e|
      e.status = :in_progress
      e.position = (task_log.task_log_entries.maximum(:position) || 0) + 1
    end

    entry.update(status: :in_progress)

    # Update task GTD status
    @task.update(gtd_status: :in_progress)

    # Start timer tracking in session
    session[:active_task_id] = @task.id
    session[:timer_start] = Time.current.to_i

    respond_to do |format|
      format.html { redirect_back(fallback_location: tasks_path, notice: "Task started.") }
      format.turbo_stream { render turbo_stream: turbo_stream.update("active-task-bar", partial: "shared/active_task_bar") }
    end
  end

  def pause
    @task = current_user.tasks.find(params[:task_id])
    entry = @task.task_log_entries.joins(:task_log).find_by(task_logs: { log_date: Date.current })

    if entry&.in_progress?
      time_spent = session[:timer_start] ? Time.current.to_i - session[:timer_start].to_i : 0
      entry.update(
        status: :pending,
        time_spent: entry.time_spent + time_spent
      )
    end

    @task.update(gtd_status: :on_hold) if @task.gtd_in_progress?

    session.delete(:active_task_id)
    session.delete(:timer_start)

    respond_to do |format|
      format.html { redirect_back(fallback_location: tasks_path, notice: "Task paused.") }
      format.turbo_stream { render turbo_stream: turbo_stream.update("active-task-bar", partial: "shared/active_task_bar") }
    end
  end

  def complete
    @task = current_user.tasks.find(params[:task_id])
    entry = @task.task_log_entries.joins(:task_log).find_by(task_logs: { log_date: Date.current })

    if entry&.in_progress? || entry&.pending?
      time_spent = if session[:timer_start] && entry&.in_progress?
        Time.current.to_i - session[:timer_start].to_i
      else
        0
      end

      entry.update(
        status: :completed,
        time_spent: entry.time_spent + time_spent
      )
    end

    @task.update(gtd_status: :completed)

    session.delete(:active_task_id)
    session.delete(:timer_start)

    respond_to do |format|
      format.html { redirect_back(fallback_location: tasks_path, notice: "Task completed!") }
      format.turbo_stream { render turbo_stream: turbo_stream.update("active-task-bar", partial: "shared/active_task_bar") }
    end
  end

  def status
    @active_task = current_user.tasks.find_by(id: session[:active_task_id]) if session[:active_task_id]
    render partial: "shared/active_task_bar"
  end
end
