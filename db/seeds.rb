# db/seeds.rb

# Create cities
cities = [
  { name: 'Mumbai', location: 'Maharashtra' },
  { name: 'Delhi', location: 'Delhi' },
  { name: 'Kolkata', location: 'West Bengal' },
  { name: 'Chennai', location: 'Tamil Nadu' },
  { name: 'Bangalore', location: 'Karnataka' },
  # Add more cities as needed
]

cities.each do |city_data|
  City.find_or_create_by(name: city_data[:name]) do |city|
    city.update(city_data)
  end
end

# Create routes
routes = [
  { start_city_name: 'Mumbai', end_city_name: 'Delhi', duration: 144 }, # Dummy duration in minutes
  { start_city_name: 'Mumbai', end_city_name: 'Kolkata', duration: 140 },
  { start_city_name: 'Delhi', end_city_name: 'Kolkata', duration: 40 },
  { start_city_name: 'Delhi', end_city_name: 'Chennai', duration: 12440 },
  { start_city_name: 'Kolkata', end_city_name: 'Chennai', duration: 400 },
  # Add more routes as needed
]

routes.each do |route_data|
  start_city = City.find_by(name: route_data[:start_city_name])
  end_city = City.find_by(name: route_data[:end_city_name])
  Route.create(start_city_id: start_city.id, end_city_id: end_city.id, duration: route_data[:duration])
end
