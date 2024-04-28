class Route < ApplicationRecord
  belongs_to :start_city, class_name: 'City'
  belongs_to :end_city, class_name: 'City'

  def self.shortest_path(start_city, end_city, intermediate_cities = [])
    distances = initialize_distances(start_city)
    previous = {}
    total_duration = 0

    pq = PriorityQueue.new
    pq.push(start_city, 0)

    while !pq.empty?
      current_city = pq.pop

      break if current_city == end_city

      update_distances_and_previous(current_city, distances, previous, pq)

      total_duration = update_total_duration(current_city, previous, total_duration)
    end

    shortest_path = reconstruct_shortest_path(end_city, previous)
    total_duration += calculate_total_duration(shortest_path)

    include_intermediate_cities(start_city, end_city, intermediate_cities, shortest_path, total_duration)

    { path: shortest_path, total_duration: total_duration }
  end

  def self.initialize_distances(start_city)
    distances = Hash.new(Float::INFINITY)
    distances[start_city] = 0
    distances
  end

  def self.update_distances_and_previous(current_city, distances, previous, pq)
    current_city.routes_as_start.each do |route|
      neighbor_city = route.end_city
      alt_distance = distances[current_city] + route.duration
      if alt_distance < distances[neighbor_city]
        distances[neighbor_city] = alt_distance
        previous[neighbor_city] = current_city
        pq.push(neighbor_city, alt_distance)
      end
    end
  end

  def self.update_total_duration(current_city, previous, total_duration)
    route_to_previous = Route.find_by(start_city_id: previous[current_city]&.id, end_city_id: current_city.id)
    total_duration += route_to_previous.duration if route_to_previous
    total_duration
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

  def self.calculate_total_duration(shortest_path)
    total_duration = 0
    shortest_path.each_with_index do |city, index|
      next if index == 0

      route_to_previous = Route.find_by(start_city_id: shortest_path[index - 1].id, end_city_id: city.id)
      total_duration += route_to_previous.duration if route_to_previous
    end
    total_duration
  end

  def self.include_intermediate_cities(start_city, end_city, intermediate_cities, shortest_path, total_duration)
    intermediate_cities.each do |city_name|
      city = City.find_by(name: city_name)
      next unless city && shortest_path.include?(end_city)

      shortest_path.insert(shortest_path.index(end_city), city)
      route_to_intermediate = Route.find_by(start_city_id: shortest_path[shortest_path.index(city) - 1].id, end_city_id: city.id)
      total_duration += route_to_intermediate.duration if route_to_intermediate
    end
  end
end
