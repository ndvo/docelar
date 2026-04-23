class PhysiciansController < ApplicationController
  before_action :require_authentication
  before_action :set_physician, only: [:edit, :update, :destroy]

  def index
    @physicians = Physician.order(:name)
  end

  def new
    @physician = Physician.new
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
      render :new
    end
  end

  def edit
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
end
