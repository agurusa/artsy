class Word < ActiveRecord::Base
  belongs_to :color
  has_many :relationships
  has_many :emotions, through: :relationships
end
