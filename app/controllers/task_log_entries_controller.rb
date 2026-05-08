class TaskLogEntriesController < ApplicationController
  before_action :require_authentication

  def update_position
    new_position = params[:position].to_i
    entry = find_authorized_entry(params[:id])

    if entry
      old_position = entry.position
      entry.update(position: new_position)
      reorder_siblings(entry.task_log, entry.id, old_position, new_position)
      head :ok
    else
      head :forbidden
    end
  end

  def update
    entry = find_authorized_entry(params[:id])
    if entry
      if entry.update(task_log_entry_params)
        redirect_back(fallback_location: entry.task_log, notice: "Entry updated successfully.")
      else
        redirect_back(fallback_location: entry.task_log, alert: "Failed to update entry.")
      end
    else
      redirect_to task_logs_path, alert: "Entry not found or not authorized."
    end
  end

  def destroy
    entry = find_authorized_entry(params[:id])
    if entry
      task_log = entry.task_log
      entry.destroy
      redirect_to task_log, notice: "Entry removed from log."
    else
      redirect_to task_logs_path, alert: "Entry not found or not authorized."
    end
  end

  private

  def find_authorized_entry(id)
    # Simpler approach: find the entry, then check if it belongs to the current user
    entry = TaskLogEntry.find_by(id: id)
    return nil unless entry
    return nil unless entry.task_log.user == current_user
    entry
  end

  def reorder_siblings(task_log, entry_id, old_position, new_position)
    entries = task_log.task_log_entries.where.not(id: entry_id).ordered

    if new_position > old_position
      entries.where(position: (old_position + 1)..new_position).each do |e|
        e.update(position: e.position - 1)
      end
    else
      entries.where(position: new_position..(old_position - 1)).each do |e|
        e.update(position: e.position + 1)
      end
    end
  end

  def task_log_entry_params
    params.require(:task_log_entry).permit(:status, :time_spent, :notes, :position)
  end
end
