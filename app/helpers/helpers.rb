class Helpers

  def self.current_user(session_hash)
    @user = User.find_by(id: session_hash[:user_id])
  end

  def self.is_logged_in?(session_hash)
    User.find_by(id: session_hash[:user_id]) != nil
  end

  def slug
    name.downcase.gsub(' ', '-')
  end

  def self.find_by_slug(slug)
    self.all.detect{|a| a.name.downcase.gsub(' ', '-') == slug}
  end
end
