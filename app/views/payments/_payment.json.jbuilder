json.extract! payment, :id, :value, :date, :purchase_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
