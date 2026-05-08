class TaskLogsController < ApplicationController
  before_action :require_authentication
  before_action :set_task_log, only: [:show, :edit, :update, :destroy]
  before_action :set_available_tasks, only: [:show, :new, :edit, :create]

  def index
    Rails.logger.debug "Current user: #{current_user&.id}"
    Rails.logger.debug "TaskLogs count: #{current_user.task_logs.count}"
    @task_logs = current_user.task_logs.by_date_desc
    @grouped_logs = @task_logs.group_by { |log| log.log_date.strftime("%B %Y") }
  end

  def show
    @entries = @task_log.task_log_entries.ordered.includes(:task)
    # For now, show all active tasks (not scoped to user since tasks don't have user_id)
    @available_tasks = Task.gtd_active.where.not(id: @task_log.tasks.pluck(:id))
  end

  def today
    @task_log = TaskLog.find_or_create_for_today(current_user)
    redirect_to @task_log
  end

  def new
    @task_log = current_user.task_logs.build(log_date: Date.current)
  end

  def create
    @task_log = current_user.task_logs.build(task_log_params)

    if @task_log.save
      redirect_to @task_log, notice: "Log de tarefas criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task_log.update(task_log_params)
      redirect_to @task_log, notice: "Log de tarefas atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task_log.destroy
    redirect_to task_logs_path, notice: "Log de tarefas removido com sucesso."
  end

  private

  def set_task_log
    @task_log = current_user.task_logs.find_by(id: params[:id])
    unless @task_log
      redirect_to task_logs_path, alert: "Log não encontrado ou não autorizado."
    end
  end

  def set_available_tasks
    # For now, show all active tasks
    @available_tasks = Task.gtd_active.includes(:project)
  end

  def task_log_params
    params.require(:task_log).permit(:user_id, :log_date, :title, :status)
  end
end
