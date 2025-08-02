class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  include DateNavigation
  include UserProductivity

  # GET /tasks or /tasks.json
  def index
    @tasks = tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    @task = Task.find(params[:id])
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
    @responsibles = Responsible.all
    @tasks = Task.all
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        destination = params[:data][:redirect_to] ? 'new_task_path' : task_url(@task)
        format.html { redirect_to destination, notice: "Task was successfully created." and return}
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
    Task.pending.where(id: bulk_update_params[:task_ids]).update(is_completed: true)
    Task.completed.where(id:  bulk_update_params[:all_task_ids].split -  bulk_update_params[:task_ids]).update(is_completed: false)

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Tasks was successfully updated." }
      format.json { head :no_content }
    end
  end

  def summary
    responsible_id = params[responsible_id]

    query = Task.all
    query = query.where(responsible_id:) if responsible_id
    @summary = query.group(:is_completed).count
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:responsible_id, :task_id, :name, :description, :is_completed)
    end

    def bulk_update_params
      params.permit(:all_task_ids, task_ids: [])
    end

    def index_params
      params.permit(:completed, :responsible_id)
    end

    def tasks
      filter_is_completed = index_params[:completed] || 'false'
      responsible_id = index_params[:responsible_id]

      query = Task.where(responsible_id:)
      case filter_is_completed
      when 'true'
        query.completed
      when 'false'
        query.pending
      else
        query.all
      end
    end
end
