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

  belongs_to :project

  after_initialize :set_default_state

  enum state: {
    disabled: -1,
    todo: 10,
    'in-progress': 20,
    done: 30
  }

  private

  def set_default_state
    self.state ||= :todo
  end
end
