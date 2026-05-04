class ProjectsController < ApplicationController
  before_action :require_authentication
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects.order(created_at: :desc)
    @active_projects = current_user.projects.active
    @on_hold_projects = current_user.projects.on_hold
    @completed_projects = current_user.projects.completed
    @someday_projects = current_user.projects.someday
  end

  def show
    @tasks = @project.tasks.order(created_at: :desc)
    @active_tasks = @project.tasks.gtd_active
    @completed_tasks = @project.tasks.where(gtd_status: :completed)
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to projects_path, notice: 'Projeto criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: 'Projeto atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Projeto removido com sucesso.'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :user_id,
      :name,
      :description,
      :outcome,
      :project_type,
      :category,
      :status,
      :next_review_date
    )
  end
end
