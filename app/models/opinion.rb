class Opinion < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :response, class_name: 'Response', foreign_key: :response_id
end
