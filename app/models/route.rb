class Route < ApplicationRecord
  belongs_to :start_city, class_name: 'City'
  belongs_to :end_city, class_name: 'City'

  def self.shortest_path(start_city, end_city)
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

    shortest_path
  end
end
