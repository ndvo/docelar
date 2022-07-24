class PeopleController < ApplicationController
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to @person
    else
      render action: 'edit'
    end
  end


  def new
    @person = Person.new
    @countries = Country.all
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to @person
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def person_params
    params.require(:person)
          .permit(:name, :birth,
                  nationalities_attributes: [
                    :country
                  ])
  end
end
