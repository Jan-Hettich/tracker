Given(/^(\d+) tasks? for project "(.*)"$/) do |count, project_id|
  d.given_tasks count: count, project_id: project_id
end

Given(/^a task:$/) do |table|
  @task = d.given_task table
end

When(/^I (?:try to )?create a task with:$/) do |table|
  attributes = vertical_table table
  d.create_task attributes
end

When(/^I request the task by id "(.*)"$/) do |id|
  d.get_task id
end

Then(/^the system has the tasks:$/) do |table|
  ActiveCucumber.diff_all! Task.order(:created_at), table
end

Then(/^the system has (\d+) tasks?$/) do |count|
  expect(Task.count).to eq count.to_i
end

When(/^I (?:try to )?transition the task to the "(.*)" state$/) do |next_state|
  expect(@task).to be
  d.update_task @task, state: next_state
end

Then(/^the task is in the "(.*)" state$/) do |state|
  expect(@task).to be
  expect(@task.state).to eq state
end