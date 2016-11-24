class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  serialize :honestbee_raw_info

  def self.from_omniauth_honestbee(auth, access_token)
    # Case 1: Find existing user by email
    existing_user = User.find_by_email( auth["email"])
    if existing_user
      existing_user.hb_access_token = access_token
      existing_user.honestbee_raw_info = auth
      existing_user.save!
      return existing_user
    end

    # Case 3: Create new user
    user = User.new
    user.hb_access_token = access_token
    user.username = auth["name"]
    user.email = auth["email"]
    user.password = Devise.friendly_token[0,20]
    user.honestbee_raw_info = auth
    user.save!
    return user
  end
end
