class Spot < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 1 }
  validates :lat, presence: true
  validates :lon, presence: true
end
