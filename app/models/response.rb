class Response < ActiveRecord::Base
  belongs_to :user
  belongs_to :response
  has_many :responses
end
