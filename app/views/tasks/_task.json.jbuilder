json.extract! task, :id, :user_id, :task_id, :name, :description, :created_at, :updated_at
json.url task_url(task, format: :json)
