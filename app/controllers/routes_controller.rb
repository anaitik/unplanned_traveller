class RoutesController < ApplicationController
  def shortest_path
    start_city = City.find_by(name: params[:start_city])
    end_city = City.find_by(name: params[:end_city])
    intermediate_cities = params[:intermediate_cities].split(',') if params[:intermediate_cities].present?

    if start_city && end_city
      shortest_path = Route.shortest_path(start_city, end_city, intermediate_cities)
      render json: { shortest_path: shortest_path.map(&:name) }
    else
      render json: { error: 'One or both cities not found' }, status: :not_found
    end
  end
end