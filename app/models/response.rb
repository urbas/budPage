class Response < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :parent_response, class_name: 'Response', foreign_key: :parent_id
  has_many :responses, class_name: 'Response', foreign_key: :parent_id
  has_many :opinions, class_name: 'Opinion', foreign_key: :response_id

  def likes_count
    opinions.where(value: true).count
  end

  def dislikes_count
    opinions.where(value: false).count
  end
end
