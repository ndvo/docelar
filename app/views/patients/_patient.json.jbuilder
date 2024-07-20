json.extract! patient, :id, :individual_id, :individual_type, :created_at, :updated_at
json.url patient_url(patient, format: :json)
