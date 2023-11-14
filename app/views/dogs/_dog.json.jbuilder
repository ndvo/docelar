json.extract! dog, :id, :ownership_id, :race, :sex, :birth, :name, :created_at, :updated_at
json.url dog_url(dog, format: :json)
