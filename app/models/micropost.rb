class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) { where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present? }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

private
 # アップロードされた画像のサイズをバリデーションする
  def picture_size
   if picture.size > 5.megabytes
   	errors.add(:picture, "should be less than 5MB")
   end
  end
end
