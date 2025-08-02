class ResponsiblesController < ApplicationController
  def create
    @person = Person.find(params[:person_id])
    @responsible = @person.create_responsible!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(@person.id, partial: 'people/show')
        ]
      end
    end
  end
end
