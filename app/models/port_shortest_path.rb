class PortShortestPath
  def self.shortest_path(start_port, end_port, intermediate_ports = [], custom_durations = {})
    distances = {}
    previous = {}
    total_duration = 0
    total_route_duration = 0

    distances[start_port] = 0
    pq = PortPriorityQueue.new
    pq.push(start_port, 0)

    while !pq.empty?
      current_port = pq.pop

      break if current_port == end_port

      update_distances_and_previous(current_port, distances, previous, pq, custom_durations)
    end

    shortest_path = reconstruct_shortest_path(end_port, previous)
    total_duration += calculate_total_duration(shortest_path, custom_durations)
    total_route_duration += calculate_route_duration(current_port, previous, custom_durations, intermediate_ports)
    include_intermediate_ports(start_port, end_port, intermediate_ports, shortest_path, total_duration, custom_durations)

    { path: shortest_path, total_duration: total_duration, total_route_duration: total_route_duration }
  end

  private

  def self.update_distances_and_previous(current_port, distances, previous, pq, custom_durations)
    current_port.routes_as_start.each do |route|
      neighbor_port = route.end_port
      alt_distance = distances[current_port] + (custom_durations[current_port.name] || route.duration)
      if alt_distance < (distances[neighbor_port] || Float::INFINITY)
        distances[neighbor_port] = alt_distance
        previous[neighbor_port] = current_port
        pq.push(neighbor_port, alt_distance)
      end
    end
  end

  def self.calculate_route_duration(current_port, previous, custom_durations, intermediate_ports = [])
    return 0 unless previous[current_port]

    route_duration_between_ports = 0
    node = current_port

    while previous[node]
      route = PortRoute.find_by(start_port_id: previous[node].id, end_port_id: node.id)
      route_duration_between_ports += route&.duration || 0
      # Add custom duration only if the previous node (port) is in intermediate ports
      route_duration_between_ports += custom_durations[previous[node].name] || 0 if intermediate_ports.include?(previous[node].name)
      node = previous[node]
    end

    route_duration_between_ports
  end

  def self.reconstruct_shortest_path(end_port, previous)
    shortest_path = []
    node = end_port
    while node
      shortest_path.unshift(node)
      node = previous[node]
    end
    shortest_path
  end

  def self.calculate_total_duration(shortest_path, custom_durations)
    total_duration = 0
    shortest_path.each_with_index do |port, index|
      next if index == 0

      total_duration += custom_durations[port.name] || 0
    end
    total_duration
  end

  def self.include_intermediate_ports(start_port, end_port, intermediate_ports, shortest_path, total_duration, custom_durations)
    return { path: shortest_path, total_duration: total_duration } unless intermediate_ports

    intermediate_ports.each do |port_name|
      port = Port.find_by(name: port_name)
      next unless port && shortest_path.include?(end_port)

      index = shortest_path.index(end_port)
      shortest_path.insert(index, port)
      total_duration += custom_durations[port.name] || 0
    end

    # Remove duplicates from the shortest path
    shortest_path.uniq!

    { path: shortest_path, total_duration: total_duration }
  end
end
