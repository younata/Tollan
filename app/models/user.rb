class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates_presence_of :password, :on => :create

  has_secure_password

  def create_api_token
    if self.api_token == nil
      begin
        self.api_token = SecureRandom.hex
      end while self.class.exists?(api_token: api_token)
      self.save
    end
  end
end
