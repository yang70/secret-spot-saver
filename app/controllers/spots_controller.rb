class SpotsController < ApplicationController
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
