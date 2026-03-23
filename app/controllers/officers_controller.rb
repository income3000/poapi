class OfficersController < ApplicationController
  before_action :set_officer, only: %i[ show update destroy ]

  # GET /officers
  def index
    @officers = Officer.all

    render json: @officers
  end

  # GET /officers/1
  def show
    render json: @officer
  end

  # POST /officers
  def create
    @officer = Officer.new(officer_params)

    if @officer.save
      render json: @officer, status: :created, location: @officer
    else
      render json: @officer.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /officers/1
  def update
    if @officer.update(officer_params)
      render json: @officer
    else
      render json: @officer.errors, status: :unprocessable_content
    end
  end

  # DELETE /officers/1
  def destroy
    @officer.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_officer
      @officer = Officer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def officer_params
      params.expect(officer: [ :name, :bn, :incident ])
    end
end
