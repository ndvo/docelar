class HabitsController < ApplicationController
  before_action :require_authentication
  before_action :set_habit, only: [:show, :edit, :update, :destroy, :toggle]

  def index
    @habits = current_user.habits.order(active: :desc, name: :asc)

    if params[:type].present?
      @habits = @habits.by_type(params[:type])
    end

    if params[:frequency].present?
      @habits = @habits.by_frequency(params[:frequency])
    end
  end

  def show
    @year = (params[:year] || Date.current.year).to_i
    @month = (params[:month] || Date.current.month).to_i
    @date = Date.new(@year, @month, 1)

    @records = @habit.habit_records.for_range(@date.beginning_of_month, @date.end_of_month)
      .index_by(&:record_date)
  end

  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(habit_params)

    if @habit.save
      redirect_to @habit, notice: 'Hábito criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @habit.update(habit_params)
      redirect_to @habit, notice: 'Hábito atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
    redirect_to habits_path, notice: 'Hábito removido com sucesso.'
  end

  def toggle
    record = @habit.habit_records.find_or_initialize_by(record_date: params[:date])
    record.completed = !record.completed
    record.save!

    redirect_back fallback_location: @habit, notice: record.completed ? 'Hábito concluído!' : 'Hábito marcado como pendente.'
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(
      :name, :description, :frequency_type, :frequency_config,
      :habit_type, :catholic_category, :target_streak,
      :reminder_time, :active
    )
  end
end
