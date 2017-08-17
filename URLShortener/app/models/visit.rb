# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  url_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  validates :user_id, :url_id, presence: true

  belongs_to :visitors,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  def self.record_visit!(user, shortened_url)
    uid = user.id
    s_url_id = shortened_url.id
    Visit.create!({ :user_id => uid, :url_id => s_url_id })
  end

end
