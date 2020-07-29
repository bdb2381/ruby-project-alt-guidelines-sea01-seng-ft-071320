class TrimWhitespace < ActiveRecord::Migration[5.2]
  def change
        update 'UPDATE officers SET officer_name = TRIM(officer_name), badge_number = TRIM(badge_number),   preicient= TRIM(  preicient  ),  unit = TRIM(  unit  ),   rank = TRIM( rank   )    '

        update 'UPDATE reviews SET user_id = TRIM(user_id), officer_id = TRIM(officer_id), rating = TRIM( rating ),  review_desc= TRIM(review_desc  )'
    
    
        update 'UPDATE users SET username = TRIM(username), password = TRIM(password), location = TRIM(location  ),  race= TRIM(race  ),  gender= TRIM(  gender)'
     
    
    
  end
end
