class User < ActiveRecord::Base
  before_create :generate_api_token

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates_presence_of :password, :on => :create

  has_secure_password

private

  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token)
  end
end
