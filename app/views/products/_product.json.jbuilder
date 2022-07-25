json.extract! product, :id, :name, :description, :brand, :kind, :created_at, :updated_at
json.url product_url(product, format: :json)
