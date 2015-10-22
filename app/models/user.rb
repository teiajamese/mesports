class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  #def self.from_omniauth(auth)
  #where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
   # user.email = auth.info.email
    #user.password = Devise.friendly_token[0,20]
    #user.name = auth.info.name   # assuming the user model has a name
    #user.image = auth.info.image # assuming the user model has an image
  #end

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
        if user.present?
            user
        else
            user = User.create(first_name:auth.extra.raw_info.first_name,
                   last_name:auth.extra.raw_info.last_name,
                   provider:auth.provider,
                   uid:auth.uid,
                   email:auth.info.email,
                   password:Devise.friendly_token[0,20])
        end
    end

   def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end


