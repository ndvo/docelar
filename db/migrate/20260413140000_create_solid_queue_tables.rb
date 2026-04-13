class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id
      t.text :executions
      t.integer :attempt, default: 0
      t.text :exception_backtrace
      t.timestamp :locked_at
      t.timestamp :locked_by
      t.timestamp :available_at, null: false
      t.timestamp :created_at, null: false
      t.index [:queue_name, :available_at], name: "index_solid_queue_jobs_on_queue_name_and_available_at"
      t.index [:priority, :available_at], name: "index_solid_queue_jobs_on_priority_and_available_at", order: { priority: "DESC", available_at: "ASC" }
      t.index [:active_job_id], name: "index_solid_queue_jobs_on_active_job_id"
    end

    create_table :solid_queue_scheduled_jobs do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id
      t.integer :attempt, default: 0
      t.timestamp :available_at, null: false
      t.timestamp :created_at, null: false
      t.index [:available_at], name: "index_solid_queue_scheduled_jobs_on_available_at"
      t.index [:priority, :available_at], name: "index_solid_queue_scheduled_jobs_on_priority_and_available_at", order: { priority: "DESC", available_at: "ASC" }
      t.index [:queue_name, :available_at], name: "index_solid_queue_scheduled_jobs_on_queue_name_and_available_at"
    end

    create_table :solid_queue_failed_executions do |t|
      t.references :job, index: { unique: true }, null: false
      t.text :exception
      t.timestamp :failed_at, null: false
    end

    create_table :solid_queue_processes do |t|
      t.string :name, null: false
      t.string :hostname, null: false
      t.integer :pid, null: false
      t.string :kind, null: false
      t.timestamp :started_at, null: false
      t.timestamp :stopped_at
      t.json :metadata
      t.timestamp :last_heartbeat_at
      t.references :supervisor, index: { name: "index_solid_queue_processes_on_supervisor_id" }
      t.index [:hostname, :started_at], name: "index_solid_queue_processes_on_hostname_and_started_at"
    end

    create_table :solid_queue_claimed_executions do |t|
      t.references :execution, null: false, index: false
      t.references :process, null: false, index: false
      t.timestamp :claimed_at, null: false
      t.index [:execution_id], name: "index_solid_queue_claimed_executions_on_execution_id"
      t.index [:process_id], name: "index_solid_queue_claimed_executions_on_process_id"
    end
  end
end
