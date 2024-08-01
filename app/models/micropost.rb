class Micropost < ApplicationRecord
  ALLOWED_PARAMS = %i(password password_confirmation).freeze
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.micropost.image.height,
                                         Settings.micropost.image.width]
  end
  scope :recent_posts, ->{order(created_at: :desc)}
  scope :relate_post, ->(user_ids){where user_id: user_ids}

  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("message.image_format")},
             size: {less_than: 5.megabytes,
                    message: I18n.t("message.size_max")}
end
