class Team < ActiveRecord::Base
    belongs_to :user
    has_many :players

    def slug
      username.downcase.gsub(' ', '-')
    end

    def self.find_by_slug(slug)
      self.all.detect{|a| a.username.downcase.gsub(' ', '-') == slug}
    end
end
