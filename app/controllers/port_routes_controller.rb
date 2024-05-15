# app/controllers/port_routes_controller.rb
class PortRoutesController < ApplicationController
  def shortest_path
    start_port = Port.find_by(name: params[:start_port])
    end_port = Port.find_by(name: params[:end_port])
    intermediate_ports = params[:intermediate_ports].split(',') if params[:intermediate_ports].present?

    if start_port && end_port
      result = PortShortestPath.shortest_path(start_port, end_port, intermediate_ports, params[:custom_durations])
      path = result[:path].map(&:name) # Accessing the name attribute correctly
      total_duration = result[:total_duration]
      total_route_duration = result[:total_route_duration]
      route_duration_between_ports = result[:route_duration_between_ports] # Extracting route_duration_between_ports from the result
      render json: { shortest_path: path, total_duration: total_duration, total_route_duration: total_route_duration, route_duration_between_ports: route_duration_between_ports } # Rendering route_duration_between_ports
    else
      render json: { error: 'One or both ports not found' }, status: :not_found
    end
  end
end
