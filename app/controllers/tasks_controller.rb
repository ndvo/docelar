class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  include DateNavigation

  # GET /tasks or /tasks.json
  def index
    @filter_is_completed = index_params[:completed] || 'false'
    case @filter_is_completed
    when 'true'
      @tasks = Task.completed
    when 'false'
      @tasks = Task.pending
    else
      @tasks = Task.all
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @users = User.all
    @tasks = Task.all
  end

  # GET /tasks/1/edit
  def edit
    @users = User.all
    @tasks = Task.all
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:user_id, :task_id, :name, :description, :is_completed)
    end

    def bulk_update_params
      params.permit(:all_task_ids, task_ids: [])
    end

    def index_params
      params.permit(:completed)
    end
end
