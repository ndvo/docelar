class RecurringTaskGenerator
  def self.generate_next(task)
    return unless task.recurring? && task.recurring_task_id.nil? && task.due_date

    next_due_date = calculate_next_due_date(task)
    return unless next_due_date

    Task.create(
      name: task.name,
      description: task.description,
      responsible: task.responsible,
      task: task.task,
      due_date: next_due_date,
      due_time: task.due_time,
      recurrence_rule: task.recurrence_rule,
      recurring_task: task
    )
  end

  private

  def self.calculate_next_due_date(task)
    case task.recurrence_rule
    when 'daily'
      task.due_date + 1.day
    when 'weekly'
      task.due_date + 1.week
    when 'monthly'
      task.due_date + 1.month
    when 'yearly'
      task.due_date + 1.year
    end
  end
end
