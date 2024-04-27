# app/models/city.rb
class City < ApplicationRecord
  has_many :routes_as_start, class_name: 'Route', foreign_key: 'start_city_id'
  has_many :routes_as_end, class_name: 'Route', foreign_key: 'end_city_id'
end
