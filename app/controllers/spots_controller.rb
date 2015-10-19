class SpotsController < ApplicationController
  def index
    spots = Spot.all
    render json: spots, status: 200
  end

  def show
    spot = Spot.find(params[:id])
    render json: spot, status: 200
  end

  def create
    spot = Spot.new(spot_params)
    if spot.save
      render json: spot, status: 201, location: spot
    else
      render json: spot.errors, status: 422
    end
  end

  def update
    spot = Spot.find(params[:id])
    if spot.update(spot_params)
      render json: spot, status: 200
    else
      render json: spot.errors, status: :unprocessable_entity
    end
  end

  def destroy
    spot = Spot.find(params[:id])
    spot.destroy
    render json: { message: "Spot deleted" }, status: 200
  end

  private

  def spot_params
    params.require(:spot).permit(:name, :lat, :lon, :water_type, :technique, :notes)
  end
end
