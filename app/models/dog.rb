class Dog < ApplicationRecord
  has_one_attached :image

  def age
    return nil unless birth
    today = Date.today
    age = today.year - birth.year
    age -= 1 if today.month < birth.month || (today.month == birth.month && today.day < birth.day)
    age
  end
end
