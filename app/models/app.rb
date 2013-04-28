class App < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  validates :user_id, presence: true

  default_scope order: 'apps.created_at DESC'
end
