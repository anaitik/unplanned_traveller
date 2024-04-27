# app/models/priority_queue.rb
class PriorityQueue
  def initialize
    @queue = []
  end

  def push(vertex, distance)
    @queue << [vertex, distance]
    @queue.sort_by! { |_, d| d }
  end

  def pop
    @queue.shift&.first
  end

  def empty?
    @queue.empty?
  end
end
