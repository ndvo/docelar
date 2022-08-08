class Product < ApplicationRecord
  validate_uniqueness_of :name, scope: %i[brand kind]
end
