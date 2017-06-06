# == Schema Information
#
# Table name: tasks
#
#  id          :uuid             not null, primary key
#  project_id  :uuid             not null
#  name        :string
#  description :text
#  state       :integer          default(10)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#

class Task < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :state, presence: true
  validates :project, presence: true
  validate :state_transitions, on: :update

  belongs_to :project

  after_initialize :set_default_state

  enum state: {
    disabled: -1,
    todo: 10,
    'in-progress': 20,
    done: 30
  }

  @@valid_transitions = [['todo', 'in-progress'], ['in-progress', 'todo'], ['in-progress', 'done']]

  def Task.valid_transition? old_state, new_state
    @@valid_transitions.include? [old_state.to_s, new_state.to_s]
  end

  def state_transitions
    errors.add(:state, 'transition invalid!') if !Task.valid_transition?(state_was, state)
  end

  private

  def set_default_state
    self.state ||= :todo
  end
end
