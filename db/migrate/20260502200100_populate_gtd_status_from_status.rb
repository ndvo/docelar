class PopulateGtdStatusFromStatus < ActiveRecord::Migration[8.0]
  # Status mapping from old status to new gtd_status
  # idea -> inbox
  # planned -> next_action
  # scheduled -> scheduled
  # waiting -> waiting_for
  # in_progress -> in_progress
  # paused -> on_hold
  # completed -> completed
  # cancelled -> dropped
  # missed -> missed

  def up
    # Use update_all with parameterized queries to avoid SQL injection
    # Map old status values to new gtd_status values
    update_tasks_by_status('idea', 'inbox')
    update_tasks_by_status('planned', 'next_action')
    update_tasks_by_status('scheduled', 'scheduled')
    update_tasks_by_status('waiting', 'waiting_for')
    update_tasks_by_status('in_progress', 'in_progress')
    update_tasks_by_status('paused', 'on_hold')
    update_tasks_by_status('completed', 'completed')
    update_tasks_by_status('cancelled', 'dropped')
    update_tasks_by_status('missed', 'missed')
  end

  def down
    # Reset gtd_status to NULL on rollback
    Task.update_all(gtd_status: nil)
  end

  private

  def update_tasks_by_status(old_status, new_gtd_status)
    Task.where(status: old_status).update_all(gtd_status: new_gtd_status)
  end
end
