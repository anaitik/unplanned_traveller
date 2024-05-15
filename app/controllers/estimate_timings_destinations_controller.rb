
require 'rest-client'
require 'json'
require 'net/http'



class EstimateTimingsDestinationsController < ApplicationController

 def estimated_time
    start_port_name = params[:start_port]
    end_port_name = params[:end_port]

    # Fetching latitude and longitude for start and end ports using a third-party geocoding service
    start_port_coordinates = geocode_port(start_port_name)
    end_port_coordinates = geocode_port(end_port_name)

    if start_port_coordinates && end_port_coordinates
      # Using the Google Maps Distance Matrix API to get the estimated duration between two points
      distance_matrix_response = distance_matrix_api_response(start_port_coordinates, end_port_coordinates)
      
      if distance_matrix_response['status'] == 'OK'
        # Extracting the estimated duration from the API response
        estimated_time = distance_matrix_response['rows'][0]['elements'][0]['duration']['value'] / 24*60*60 # Converting seconds to minutes
        render json: { estimated_time: estimated_time }
      else
        render json: { error: 'Error fetching distance matrix data' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid start or end port' }, status: :unprocessable_entity
    end
  end

  private

	  def geocode_port(port_name)
	  # Replace 'YOUR_API_KEY' with your actual Google Maps API key
	  url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(port_name)}&key=YOUR_API_KEY"
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
    uri = URI("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=#{start_coordinates}&destinations=#{end_coordinates}&key=#{api_key}")
    response = RestClient.get(url)
    JSON.parse(response.body)
  end
end