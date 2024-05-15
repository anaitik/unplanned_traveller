require 'rest-client'
require 'json'
require 'net/http'

class EstimateTimingsDestinationsController < ApplicationController
  def estimated_time
    start_destination = params[:start_destination]
    end_destination = params[:end_destination]

    # Fetching latitude and longitude for start and end destinations using a third-party geocoding service
    start_coordinates = geocode_destination(start_destination)
    end_coordinates = geocode_destination(end_destination)

    if start_coordinates && end_coordinates
      # Using the Google Maps Distance Matrix API to get the estimated duration between two points
      distance_matrix_response = distance_matrix_api_response(start_coordinates, end_coordinates)
      
      if distance_matrix_response['status'] == 'OK'
        # Extracting the estimated duration from the API response
        estimated_time = distance_matrix_response['rows'][0]['elements'][0]['duration']['value'] / 24*60*60 # Converting seconds to days
        render json: { estimated_time: estimated_time }
      else
        render json: { error: 'Error fetching distance matrix data' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid start or end destination' }, status: :unprocessable_entity
    end
  end

  private

  def geocode_destination(destination_name)
    # Replace 'YOUR_API_KEY' with your actual Google Maps API key
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(destination_name)}&key=YOUR_API_KEY"
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    if data['status'] == 'OK'
      location = data['results'][0]['geometry']['location']
      "#{location['lat']},#{location['lng']}"
    else
      nil
    end
  end

  def distance_matrix_api_response(start_coordinates, end_coordinates)
    # Call the Google Maps Distance Matrix API to get the distance and duration between two points
    # Replace 'YOUR_API_KEY' with your actual Google Maps API key
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=#{start_coordinates}&destinations=#{end_coordinates}&key=YOUR_API_KEY"
    response = RestClient.get(url)
    JSON.parse(response.body)
  end
end
