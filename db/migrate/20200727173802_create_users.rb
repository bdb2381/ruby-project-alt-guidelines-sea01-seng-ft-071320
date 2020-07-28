class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :location
      t.string :race
      t.string :gender
    end
  end 
end
