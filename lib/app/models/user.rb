class User < ActiveRecord::Base
    has_many :reviews
    has_many :officers, through: :reviews
end