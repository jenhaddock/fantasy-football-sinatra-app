class Team < ActiveRecord::Base
  extend Concerns::Slugify
  include Concerns::Slugify

  belongs_to :user
  has_many :players
end
