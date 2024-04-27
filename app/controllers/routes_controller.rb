# app/controllers/routes_controller.rb
class RoutesController < ApplicationController
  def shortest_path
    start_city = City.find_by(name: params[:start_city])
    end_city = City.find_by(name: params[:end_city])

    if start_city && end_city
      shortest_path = Route.shortest_path(start_city, end_city)
      render json: { shortest_path: shortest_path.map(&:name) }
    else
      render json: { error: 'One or both cities not found' }, status: :not_found
    end
  end
end