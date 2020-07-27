class Review < ActiveRecord::Base
    belongs_to :officer
    belongs_to :user
end