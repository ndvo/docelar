json.extract! purchase, :id, :price, :product_id, :downpayment_id, :installments_id, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
