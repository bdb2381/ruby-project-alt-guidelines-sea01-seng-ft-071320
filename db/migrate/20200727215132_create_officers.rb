class CreateOfficers < ActiveRecord::Migration[5.2]
  def change
    create_table :officers do |t|
      t.string :officer_name
      t.string :badge_number  #could be af3413
      t.string :preicient 
      t.string :unit 
      t.string :rank 
    end
  end
end
