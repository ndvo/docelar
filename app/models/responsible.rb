class Responsible < ApplicationRecord
  belongs_to :person, optional: false
  has_many :tasks

  before_validation :fill_name

  def fill_name
    self.name = name.presence || person.name
  end
end
