class User < ActiveRecord::Base
  extend Concerns::Slugify
  include Concerns::Slugify

  has_secure_password

  has_many :teams
  has_many :players, through: :teams
end
