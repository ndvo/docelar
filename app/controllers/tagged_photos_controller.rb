class TaggedPhotosController < ApplicationController
  def create
    @tag = Tag.find_or_create_by(name: find_tag_params[:tag_name])
    @photo = Photo.find(create_params[:photo_id])

    @tagged_photo = TaggedPhoto.find_or_create_by(tag: @tag, photo: @photo)

    respond_to do |format|
      if @tagged_photo.save
        format.html { redirect_to photo_url(@photo), notice: "Foto marcada como #{@tag.name} com sucesso." }
        format.json { render :show, status: :created, location: @tagged_photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tagged_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_tag_params
    params.permit(:tag_name)
  end

  def create_params
    params.require(:tagged_photo).permit(:photo_id)
  end
end
