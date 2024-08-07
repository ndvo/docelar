class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  include DateNavigation

  # GET /tasks or /tasks.json
  def index
    case index_params[:completed]
    when 'true'
      @tasks = Task.where(is_completed: true)
    when 'false'
      @tasks = Task.where(is_completed: false)
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
    checked_ids = params[:task_ids]

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

    def index_params
      params.permit(:completed)
    end
end
