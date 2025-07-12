class TaggedsController < ApplicationController
  before_action :set_tagged, only: %i[ show edit update destroy ]

  # GET /taggeds or /taggeds.json
  def index
    @taggeds = Tagged.all
  end

  # GET /taggeds/1 or /taggeds/1.json
  def show
  end

  # GET /taggeds/new
  def new
    @tagged = Tagged.new
  end

  # GET /taggeds/1/edit
  def edit
  end

  # POST /taggeds or /taggeds.json
  def create
    @tagged = Tagged.new(tagged_params)

    respond_to do |format|
      if @tagged.save
        format.html { redirect_to @tagged, notice: "Tagged was successfully created." }
        format.json { render :show, status: :created, location: @tagged }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tagged.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taggeds/1 or /taggeds/1.json
  def update
    respond_to do |format|
      if @tagged.update(tagged_params)
        format.html { redirect_to @tagged, notice: "Tagged was successfully updated." }
        format.json { render :show, status: :ok, location: @tagged }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tagged.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taggeds/1 or /taggeds/1.json
  def destroy
    @tagged.destroy!

    respond_to do |format|
      format.html { redirect_to taggeds_path, status: :see_other, notice: "Tagged was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tagged
      @tagged = Tagged.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tagged_params
      params.fetch(:tagged, {})
    end
end
