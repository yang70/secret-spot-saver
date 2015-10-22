class SpotsController < ApplicationController
  before_action :authenticate_user!
  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/spots', 'List spots'
  def index
    spots = policy_scope(Spot)
    render json: spots, status: 200
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/spots/:id', 'Show a spot'
  def show
    spot = Spot.find(params[:id])
    authorize spot
    render json: spot, status: 200
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :POST, '/spots', 'Create a spot'
  param :spot, Hash do
    param :lat, :undef
    param :lon, :undef
    param :name, :undef
    param :notes, :undef
    param :technique, :undef
    param :water_type, :undef
  end
  error code: 422
  def create
    spot = Spot.new(spot_params)
    authorize spot
    if spot.save
      render json: spot, status: 201, location: spot
    else
      render json: spot.errors, status: 422
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :PATCH, '/spots/:id', 'Update a spot'
  api :PUT, '/spots/:id', 'Update a spot'
  param :spot, Hash do
    param :name, :undef
  end
  error code: 422
  def update
    spot = Spot.find(params[:id])
    authorize spot
    if spot.update(spot_params)
      render json: spot, status: 200
    else
      render json: spot.errors, status: :unprocessable_entity
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :DELETE, '/spots/:id', 'Destroy a spot'
  def destroy
    spot = Spot.find(params[:id])
    authorize spot
    spot.destroy
    render json: { message: "Spot deleted" }, status: 200
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :lat, :lon, :water_type, :technique, :notes)
  end
end
