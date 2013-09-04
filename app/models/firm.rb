class Firm < ActiveRecord::Base
  attr_accessible :building, :corporate_disclaimer, :country, :city, :latitude, :longitude, :name, :postcode, :street_address, :website, :editor_id
  has_many :users
  belongs_to :editor, class_name: "User"
  geocoded_by :full_street_address
  after_validation :geocode, :if => :address_changed?
  default_scope order('name ASC')
  # validates :name, presence: true
  # validates :city, presence: true


  def full_street_address
    "#{building}, #{street_address}, #{city}, #{postcode}, #{country}"
  end

  def address_changed?
    building_changed? || street_address_changed? || city_changed? || postcode_changed? || country_changed?
  end

  def to_string
    "#{name}, #{city}"
  end


end
