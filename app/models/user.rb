require "bcrypt"
require "dm-validations"

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String, required: true
  property :password_digest, String, length: 60

  attr_reader :password
  attr_accessor :password_test
  validates_confirmation_of(:password, confirm: :password_test)
  validates_presence_of(:email)
  validates_format_of(:email, as: :email_address)

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end
