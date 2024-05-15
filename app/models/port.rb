class Port < ApplicationRecord
	class Port < ApplicationRecord
  has_many :routes_as_start, class_name: 'PortRoute', foreign_key: 'start_port_id'
  has_many :routes_as_end, class_name: 'PortRoute', foreign_key: 'end_port_id'
end

end
