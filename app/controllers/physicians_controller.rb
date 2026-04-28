class PhysiciansController < ApplicationController
  before_action :require_authentication
  before_action :set_physician, only: [:edit, :update, :destroy]

  def index
    @physicians = Physician.order(:name)
  end

  def new
    @physician = Physician.new
    @available_people = available_people
  end

  def create
    @physician = Physician.new(physician_params)
    
    if @physician.person_id.blank? && @physician.name.present?
      name = @physician.name.sub(/\A(Dr\.?|Dra\.?)\s+/i, '')
      person = Person.find_by(name: name) || Person.create!(name: name)
      @physician.person_id = person.id
    end
    
    if @physician.save
      redirect_to physicians_path, notice: 'Médico cadastrado com sucesso.'
    else
      @available_people = available_people
      render :new
    end
  end

  def edit
    @available_people = available_people
  end

  def update
    @physician.assign_attributes(physician_params)
    
    if @physician.person_id.blank? && @physician.name.present?
      name = @physician.name.sub(/\A(Dr\.?|Dra\.?)\s+/i, '')
      person = Person.find_by(name: name) || Person.create!(name: name)
      @physician.person_id = person.id
    end
    
    if @physician.save
      redirect_to physicians_path, notice: 'Médico atualizado com sucesso.'
    else
      @available_people = available_people
      render :edit
    end
  end

  def destroy
    @physician.destroy
    redirect_to physicians_path, notice: 'Médico removido com sucesso.'
  end

  private

  def set_physician
    @physician = Physician.find(params[:id])
  end

  def physician_params
    params.require(:physician).permit(:name, :crm, :person_id)
  end

  def available_people
    used_person_ids = Physician.where.not(id: @physician.id).pluck(:person_id).compact
    Person.where.not(id: used_person_ids).order(:name)
  end
end
