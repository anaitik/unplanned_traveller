class CreatePortRoutes < ActiveRecord::Migration[7.1]
  def change
    create_table :port_routes do |t|
      t.references :start_port, null: false, foreign_key: true
      t.references :end_port, null: false, foreign_key: true
      t.integer :duration

      t.timestamps
    end
  end
end
