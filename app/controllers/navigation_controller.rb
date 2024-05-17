require 'net/http'
require 'json'

class NavigationController < ApplicationController
  def navigate
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    time = Time.parse(params[:time])
    sun_position = fetch_sun_position(latitude, longitude, params[:date])

    # Calculate observer's position based on celestial navigation
    observer_position = calculate_observer_position(latitude, longitude, time, sun_position)

    render json: { observer_position: observer_position }
  end

  private

  def fetch_sun_position(latitude, longitude, date)
    api_key = ENV['NAVIGATION_API_KEY'] # Retrieve API key from environment variable
    uri = URI("https://api.usno.navy.mil/rstt/oneday?date=#{date}&coords=#{latitude},#{longitude}&tz=0&api_key=#{api_key}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    sun_data = data['sundata'].first
    { azimuth: sun_data['azimuth'].to_f, elevation: sun_data['elevation'].to_f }
  end
  def calculate_observer_position(latitude, longitude, time, sun_position)
    # Convert latitude and longitude to radians
    lat_rad = latitude * Math::PI / 180
    lon_rad = longitude * Math::PI / 180

    # Calculate the observer's altitude (distance from the center of the Earth)
    # Adjust for atmospheric refraction and the Earth's curvature
    observer_altitude = calculate_observer_altitude(lat_rad, sun_position[:elevation], time)

    # Calculate the observer's position on the Earth's surface using spherical coordinates
    observer_x = (observer_altitude + EarthRadius) * Math.cos(lat_rad) * Math.cos(lon_rad)
    observer_y = (observer_altitude + EarthRadius) * Math.cos(lat_rad) * Math.sin(lon_rad)
    observer_z = (observer_altitude + EarthRadius) * Math.sin(lat_rad)

    # Create a hash representing the observer's adjusted position
    observer_position = { latitude: observer_x, longitude: observer_y, altitude: observer_z }

    observer_position
  end
end
