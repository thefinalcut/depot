class Product < ActiveRecord::Base
  default_scope :order => 'title'

  validates_presence_of :title, :description, :image_url
  validates :price, numericality: { :greater_than_or_equal_to => 0.01 }
  validates_uniqueness_of :title, message: "MUST BE UNIQUE"
  validates :title, length: { minimum: 10 }
  validates :image_url, format: { 
      with: %r{\.(jpg|png|gif)\z}i, 
      message: "must be a URL for GIF, JPG, or PNG image"
  }

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private
    def ensure_not_referenced_by_any_line_item
      if self.line_items.empty?
        true
      else
        errors.add(:base, 'Lines Items still refer to this product')
        false
      end
    end
end
