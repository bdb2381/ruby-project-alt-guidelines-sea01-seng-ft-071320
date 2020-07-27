class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.float :rating
      t.string :review_desc
      t.integer :user_id
      t.integer :officer_id
    end
  end
end
