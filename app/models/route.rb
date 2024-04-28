class Route < ApplicationRecord
  belongs_to :start_city, class_name: 'City'
  belongs_to :end_city, class_name: 'City'
def self.shortest_path(start_city, end_city, intermediate_cities = [])
  distances = Hash.new(Float::INFINITY)
  previous = {}

  distances[start_city] = 0
  pq = PriorityQueue.new
  pq.push(start_city, 0)

  while !pq.empty?
    current_city = pq.pop

    break if current_city == end_city

    current_city.routes_as_start.each do |route|
      neighbor_city = route.end_city
      next if intermediate_cities.include?(neighbor_city.name) && !intermediate_city_between?(current_city, neighbor_city, end_city, intermediate_cities)

      alt_distance = distances[current_city] + route.duration
      if alt_distance < distances[neighbor_city]
        distances[neighbor_city] = alt_distance
        previous[neighbor_city] = current_city
        pq.push(neighbor_city, alt_distance)
      end
    end
  end

  shortest_path = []
  node = end_city
  while node
    shortest_path.unshift(node)
    node = previous[node]
  end

  # Include intermediate cities in the path if they are specified
  if intermediate_cities.any?
    intermediate_cities.each do |city_name|
      city = City.find_by(name: city_name)
      shortest_path.insert(shortest_path.index(end_city), city) if city && shortest_path.include?(end_city)
    end
  end

  shortest_path
end

def self.intermediate_city_between?(start_city, intermediate_city, end_city, intermediate_cities)
  start_to_intermediate = intermediate_cities.index(start_city.name)
  intermediate_to_end = intermediate_cities.index(end_city.name)
  intermediate_to_check = intermediate_cities.index(intermediate_city.name)

  return false if start_to_intermediate.nil? || intermediate_to_end.nil? || intermediate_to_check.nil?

  start_to_intermediate < intermediate_to_end &&
    start_to_intermediate < intermediate_to_check && 
    intermediate_to_check < intermediate_to_end
end

end


