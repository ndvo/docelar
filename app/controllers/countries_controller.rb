class CountriesController < ApplicationController
  def index
    @countries = Country.all
  end

  def show
    @country = Country.find(params[:id])
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      redirect_to @country
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @country = Article.find(params[:id])
  end

  def update
    @country = Article.find(params[:id])
    if @country.update(country_params)
      redirect_to @country
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def country_params
    params.require(:country).permit(:name, :aka)
  end
end
