class Video < ActiveRecord::Base
  belongs_to :category
  # rails 3 syntax deprecated:
  # has_many :reviews, order: "created_at DESC"
  # rails 4 now requires scope blocks:
  has_many :reviews, -> { order 'created_at DESC' }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
end
