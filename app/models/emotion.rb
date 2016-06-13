class Emotion < ActiveRecord::Base
  has_many :relationships
  has_many :words, through: :relationships
end
