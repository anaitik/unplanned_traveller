class RoutesController < ApplicationController
  def shortest_path
    start_city = City.find_by(name: params[:start_city])
    end_city = City.find_by(name: params[:end_city])
    intermediate_cities = params[:intermediate_cities].split(',') if params[:intermediate_cities].present?

    if start_city && end_city
      result = Route.shortest_path(start_city, end_city, intermediate_cities, params[:custom_durations])
      path = result[:path].map(&:name) # Accessing the name attribute correctly
      total_duration = result[:total_duration]
      total_route_duration = result[:total_route_duration]
      route_duration_between_cities = result[:route_duration_between_cities] # Extracting route_duration_between_cities from the result
      render json: { shortest_path: path, total_duration: total_duration, total_route_duration: total_route_duration, route_duration_between_cities: route_duration_between_cities } # Rendering route_duration_between_cities
    else
      render json: { error: 'One or both cities not found' }, status: :not_found
    end
  end
end
