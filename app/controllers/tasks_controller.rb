class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  include DateNavigation
  include UserProductivity

  # GET /tasks or /tasks.json
  def index
    @tasks = tasks
    @filter_status = index_params[:status] || 'pending'
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    @tasks = tasks.where(task: @task)
  end

  # GET /tasks/new
  def new
    @parent = Task.where(id: params[:parent_id].to_i).first
    @task = Task.new(task: @parent, responsible: @parent&.responsible)
    @responsibles = Responsible.all
    @tasks = Task.all
  end

  # GET /tasks/1/edit
  def edit
    @parent = @task.task
    @responsibles = Responsible.all
    @tasks = [@parent].concat(Task.pending.where(task: @parent).order(:name)).compact
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        destination = params.dig(:data, :redirect_to) ? 'new_task_path' : task_url(@task)
        format.html { redirect_to destination, notice: "Task was successfully created." and return }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: t('messages.saved')}
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def bulk_update
    Task.pending.where(id: bulk_update_params[:task_ids]).update(status: 'completed')
    Task.where(status: ['completed', 'missed']).where(id:  bulk_update_params[:all_task_ids].split -  bulk_update_params[:task_ids]).update(status: 'pending')

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Tasks was successfully updated." }
      format.json { head :no_content }
    end
  end

  def summary
    responsible_id = params[:responsible_id]

    query = Task.all
    query = query.where(responsible_id:) if responsible_id
    @summary = query.group(:is_completed).count
  end

  # GTD Inbox - Quick capture and process inbox items
  def inbox
    @inbox_tasks = Task.gtd_inbox.order(created_at: :desc)
    @task = Task.new(status: 'idea', gtd_status: 'inbox')
  end

  # GTD Next Actions - Actionable items with filters
  def next_actions
    @next_actions = Task.gtd_next_actions.order(:priority, :due_date)
    @contexts = Task.pluck(:context).compact.uniq
    @energy_levels = Task.energy_levels.keys

    # Apply filters
    @next_actions = @next_actions.where(context: params[:context]) if params[:context].present?
    @next_actions = @next_actions.where(energy_level: params[:energy_level]) if params[:energy_level].present?
    @next_actions = @next_actions.where(priority: params[:priority]) if params[:priority].present?

    # Group by project
    @grouped_by_project = @next_actions.group_by(&:project)
  end

  # GTD Waiting For - Items waiting on others
  def waiting_for
    @waiting_tasks = Task.gtd_waiting_for.order(created_at: :desc)
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:responsible_id, :task_id, :name, :description, :status, :due_date, :due_time, :recurrence_rule, :gtd_status, :context, :energy_level, :priority, :project_id)
    end

    def bulk_update_params
      params.permit(:all_task_ids, task_ids: [])
    end

    def index_params
      params.permit(:status, :responsible_id)
    end

  def tasks
    if action_name == 'index'
      task_id = nil
    else
      task_id = params[:id]
    end
    filter_status = index_params[:status] || 'pending'
    responsible_id = index_params[:responsible_id]

    query = Task.all

    query = query.where(responsible_id:) if responsible_id.present?
    query = query.where(task_id:)
    case filter_status
    when 'completed'
      query.completed
    when 'missed'
      query.missed
    when 'cancelled'
      query.cancelled
    when 'pending'
      query.pending
    else
      query.all
    end
  end
end
