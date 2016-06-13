class Relationship < ActiveRecord::Base
  belongs_to :word
  belongs_to :emotion
end
