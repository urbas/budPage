class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :responses, class_name: 'Response', foreign_key: :user_id
  has_many :opinions, class_name: 'Opinion', foreign_key: :user_id
end
