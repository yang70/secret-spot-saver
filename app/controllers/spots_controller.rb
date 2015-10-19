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

  private

  def spot_params
    params.require(:spot).permit(:name, :lat, :lon, :water_type, :technique, :notes)
  end
end
