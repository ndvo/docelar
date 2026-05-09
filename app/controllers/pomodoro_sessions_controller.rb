class PomodoroSessionsController < ApplicationController
  before_action :require_authentication
  before_action :set_pomodoro_session, only: [:show, :complete, :destroy]
  before_action :set_task, only: [:start, :pause, :resume]
  before_action :set_project, only: [:start]

  # GET /pomodoro_sessions
  def index
    @pomodoro_sessions = current_user.pomodoro_sessions.order(started_at: :desc)

    # Filter by date range
    if params[:start_date].present? && params[:end_date].present?
      @pomodoro_sessions = @pomodoro_sessions.by_date_range(
        Date.parse(params[:start_date]),
        Date.parse(params[:end_date])
      )
    end

    # Filter by task
    if params[:task_id].present?
      @pomodoro_sessions = @pomodoro_sessions.for_task(params[:task_id])
    end

    # Filter by project
    if params[:project_id].present?
      @pomodoro_sessions = @pomodoro_sessions.for_project(params[:project_id])
    end

    # Filter by status
    if params[:status].present?
      @pomodoro_sessions = @pomodoro_sessions.where(status: params[:status])
    end
  end

  # GET /pomodoro_sessions/today
  def today
    @pomodoro_sessions = current_user.pomodoro_sessions.today.order(started_at: :desc)
    render :index
  end

  # GET /pomodoro_sessions/statistics
  def statistics
    @total_sessions = current_user.pomodoro_sessions.completed.count
    @total_time = current_user.pomodoro_sessions.completed.sum(:duration)
    @todays_count = current_user.pomodoro_sessions.completed.today.count
    @daily_pomodoro_goal = current_user.daily_pomodoro_goal

    # Daily count for last 30 days
    @daily_counts = current_user.pomodoro_sessions.completed
      .where(started_at: 30.days.ago..Time.current)
      .group("DATE(started_at)")
      .count

    # Weekly average
    @weekly_average = @daily_counts.values.sum / 4.0 # Rough 4 week average

    # Total hours by project
    @hours_by_project = current_user.pomodoro_sessions.completed
      .joins(:project)
      .group("projects.name")
      .sum(:duration)

    # Total hours by task
    @hours_by_task = current_user.pomodoro_sessions.completed
      .joins(:task)
      .group("tasks.name")
      .sum(:duration)

    # Streak tracking
    @current_streak = calculate_streak

    # Interruption statistics
    @total_interruptions = current_user.pomodoro_sessions.completed.sum(:interruptions)
    @avg_interruptions = @total_sessions > 0 ? (@total_interruptions.to_f / @total_sessions).round(2) : 0
  end

  # GET /pomodoro_sessions/1
  def show
  end

  # GET /pomodoro_sessions/1/timer
  def timer
    @pomodoro_session = current_user.pomodoro_sessions.find(params[:id])
  end

  # GET /pomodoro_sessions/new
  def new
    @pomodoro_session = current_user.pomodoro_sessions.build(
      duration: 25 * 60, # Default 25 minutes
      status: :planned
    )
    @tasks = Task.gtd_active
    @projects = current_user.projects.active
  end

  # POST /pomodoro_sessions
  def create
    @pomodoro_session = current_user.pomodoro_sessions.build(pomodoro_session_params)

    if @pomodoro_session.save
      redirect_to @pomodoro_session, notice: 'Pomodoro session was successfully created.'
    else
      @tasks = Task.gtd_active
      @projects = current_user.projects.active
      render :new, status: :unprocessable_entity
    end
  end

  # POST /pomodoro_sessions/start
  def start
    # Check if there's already an active pomodoro
    active_session = current_user.pomodoro_sessions.find_by(status: :in_progress)

    if active_session
      redirect_back(fallback_location: pomodoro_sessions_path, alert: "You already have an active pomodoro session.")
      return
    end

    @pomodoro_session = current_user.pomodoro_sessions.build(
      task: @task,
      project: @project || @task&.project,
      started_at: Time.current,
      status: :in_progress,
      duration: 25 * 60 # Default 25 minutes
    )

    if @pomodoro_session.save
      # Update task status if task is present
      @task&.update(gtd_status: :in_progress)

      respond_to do |format|
        format.html { redirect_to timer_pomodoro_session_path(@pomodoro_session), notice: 'Pomodoro started!' }
        format.turbo_stream
      end
    else
      redirect_back(fallback_location: tasks_path, alert: 'Failed to start pomodoro.')
    end
  end

  # POST /pomodoro_sessions/1/pause
  def pause
    @pomodoro_session = current_user.pomodoro_sessions.find_by(
      task: @task,
      status: :in_progress
    )

    if @pomodoro_session
      # Calculate elapsed time and update
      elapsed = Time.current - @pomodoro_session.started_at
      @pomodoro_session.update(
        status: :cancelled, # We'll treat pause as cancelled for simplicity
        ended_at: Time.current,
        duration: elapsed.to_i
      )

      @task&.update(gtd_status: :on_hold) if @task&.gtd_in_progress?
    end

    redirect_back(fallback_location: tasks_path, notice: 'Pomodoro paused.')
  end

  # POST /pomodoro_sessions/1/resume
  def resume
    # For simplicity, we'll treat resume as starting a new session
    start
  end

  # POST /pomodoro_sessions/1/complete
  def complete
    if @pomodoro_session.status_in_progress? || @pomodoro_session.status_planned?
      @pomodoro_session.complete!

      # Update task status if completed
      if @pomodoro_session.task&.pomodoro_sessions&.completed&.count.to_i > 0
        # Don't auto-complete task, just log the pomodoro
      end

      respond_to do |format|
        format.html { redirect_to pomodoro_sessions_path, notice: 'Pomodoro completed!' }
        format.turbo_stream
      end
    else
      redirect_back(fallback_location: pomodoro_sessions_path, alert: 'Pomodoro already completed or cancelled.')
    end
  end

  # POST /pomodoro_sessions/1/log_interruption
  def log_interruption
    @pomodoro_session.log_interruption!
    redirect_back(fallback_location: pomodoro_session_path(@pomodoro_session), notice: 'Interruption logged.')
  end

  # DELETE /pomodoro_sessions/1
  def destroy
    if @pomodoro_session.status_in_progress?
      @pomodoro_session.update(
        status: :cancelled,
        ended_at: Time.current
      )
    else
      @pomodoro_session.destroy
    end

    redirect_to pomodoro_sessions_path, notice: 'Pomodoro session was cancelled.'
  end

  private

  def set_pomodoro_session
    @pomodoro_session = current_user.pomodoro_sessions.find(params[:id])
  end

  def set_task
    @task = Task.find(params[:task_id]) if params[:task_id].present?
  end

  def set_project
    @project = current_user.projects.find(params[:project_id]) if params[:project_id].present?
  end

  def pomodoro_session_params
    params.require(:pomodoro_session).permit(
      :task_id,
      :project_id,
      :duration,
      :status,
      :interruptions,
      :notes,
      :started_at,
      :ended_at
    )
  end

  def calculate_streak
    streak = 0
    date = Date.current

    loop do
      break unless current_user.pomodoro_sessions.completed
        .where(started_at: date.all_day).exists?

      streak += 1
      date -= 1.day

      # Safety check to avoid infinite loop
      break if streak > 365
    end

    streak
  end
end
