class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :officer_id
      t.float :rating
      t.string :review_desc
    end
  end
end
