
# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :text             not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :short_url, uniqueness: true, presence: true
  validates :user_id, :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  def num_clicks
    visits.length
    # clicks = Visit.where(url_id: "#{self.id}")
    # clicks.length
  end

  def num_uniques
    visits.distinct.length
  end

  def recent_uniques
    ten_minutes_ago = Time.now - 10.minutes
    visits.distinct.select do |visit|
       visit.created_at >= ten_minutes_ago
    end.length
  end

  def self.random_code
    random_code = SecureRandom::urlsafe_base64
    while ShortenedUrl.exists?(random_code)
      random_code = SecureRandom::urlsafe_base64
    end
    random_code
  end

  def self.make_url(user, long_url)
    random_code = ShortenedUrl.random_code
    ShortenedUrl.create!({:short_url => random_code,
                          :long_url => long_url,
                          :user_id => user.id })
  end

end
