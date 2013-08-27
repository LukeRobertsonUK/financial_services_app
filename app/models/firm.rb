class Firm < ActiveRecord::Base
  attr_accessible :building, :corporate_disclaimer, :country, :city, :latitude, :longitude, :name, :postcode, :street_address, :website
  has_many :users
  geocoded_by :full_street_address
  after_validation :geocode, :if => :address_changed?
  default_scope order('name ASC')

  def full_street_address
    "#{building}, #{street_address}, #{city}, #{postcode}, #{country}"
  end

  def address_changed?
    building_changed? || street_address_changed? || city_changed? || postcode_changed? || country_changed?
  end

  def to_string
    "#{name} - #{full_street_address}"
  end
end
