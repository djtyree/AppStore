class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :apps, dependent: :destroy
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :fullname, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  #validation
  validates :fullname, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }

  before_save { |user| user.email = email.downcase }
  validates :password_confirmation, presence: true

end
