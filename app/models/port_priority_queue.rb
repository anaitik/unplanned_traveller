class PortPriorityQueue
  def initialize
    @queue = []
  end

  def push(port, distance)
    @queue << [port, distance]
    @queue.sort_by! { |_, d| d }
  end

  def pop
    @queue.shift&.first
  end

  def empty?
    @queue.empty?
  end
end