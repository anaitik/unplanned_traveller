class Route < ApplicationRecord
  belongs_to :start_city, class_name: 'City'
  belongs_to :end_city, class_name: 'City'
def self.shortest_path(start_city, end_city, intermediate_cities = [], custom_durations = {})
  distances = {}
  previous = {}
  total_duration = 0
  total_route_duration = 0

  distances[start_city] = 0
  pq = PriorityQueue.new
  pq.push(start_city, 0)

  while !pq.empty?
    current_city = pq.pop

    break if current_city == end_city

    update_distances_and_previous(current_city, distances, previous, pq, custom_durations)

    total_duration = update_total_duration(current_city, previous, total_duration, custom_durations)
    total_route_duration += calculate_route_duration(current_city, previous, custom_durations)
  end

  shortest_path = reconstruct_shortest_path(end_city, previous)
  total_duration += calculate_total_duration(shortest_path, custom_durations)

  include_intermediate_cities(start_city, end_city, intermediate_cities, shortest_path, total_duration, custom_durations)

  { path: shortest_path, total_duration: total_duration, total_route_duration: total_route_duration }
end


  private

  def self.update_distances_and_previous(current_city, distances, previous, pq, custom_durations)
    current_city.routes_as_start.each do |route|
      neighbor_city = route.end_city
      alt_distance = distances[current_city] + (custom_durations[current_city.name] || route.duration)
      if alt_distance < (distances[neighbor_city] || Float::INFINITY)
        distances[neighbor_city] = alt_distance
        previous[neighbor_city] = current_city
        pq.push(neighbor_city, alt_distance)
      end
    end
  end

  def self.update_total_duration(current_city, previous, total_duration, custom_durations)
    total_duration += custom_durations[current_city.name] || 0
    total_duration
  end

 def self.calculate_route_duration(current_city, previous, custom_durations)
  return 0 unless previous[current_city]

  route_duration_between_cities = 0
  node = current_city

  while previous[node]
    route = Route.find_by(start_city_id: previous[node].id, end_city_id: node.id)
    route_duration_between_cities += route&.duration 
    route_duration_between_cities += custom_durations[previous[node].name] || 0
    node = previous[node]
  end

  route_duration_between_cities
end


  def self.reconstruct_shortest_path(end_city, previous)
    shortest_path = []
    node = end_city
    while node
      shortest_path.unshift(node)
      node = previous[node]
    end
    shortest_path
  end

  def self.calculate_total_duration(shortest_path, custom_durations)
    total_duration = 0
    shortest_path.each_with_index do |city, index|
      next if index == 0

      total_duration += custom_durations[city.name] || 0
    end
    total_duration
  end

  def self.include_intermediate_cities(start_city, end_city, intermediate_cities, shortest_path, total_duration, custom_durations)
    intermediate_cities.each do |city_name|
      city = City.find_by(name: city_name)
      next unless city && shortest_path.include?(end_city)

      shortest_path.insert(shortest_path.index(end_city), city)
      total_duration += custom_durations[city.name] || 0
    end
  end
end
