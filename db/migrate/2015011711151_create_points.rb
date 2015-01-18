class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name
      t.string :city
      t.float :latitude
      t.float :longitude
      
      t.timestamps null: false
    end
  end
end