class CreateCitiesAndRoutes < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :location
      t.timestamps
    end

    create_table :routes do |t|
      t.references :start_city, foreign_key: { to_table: :cities }, null: false
      t.references :end_city, foreign_key: { to_table: :cities }, null: false
      t.integer :duration
      t.timestamps
    end
  end
end
