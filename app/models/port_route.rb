class PortRoute < ApplicationRecord
  belongs_to :start_port, class_name: 'Port'
  belongs_to :end_port, class_name: 'Port'
end
