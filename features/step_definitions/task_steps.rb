Given(/^(\d+) tasks? for project "(.*)"$/) do |count, project_id|
  d.given_tasks count: count, project_id: project_id
end

Given(/^a task:$/) do |table|
  @the_task = d.given_task table
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
  d.update_task @the_task, state: next_state
end

Then(/^the task is in the "(.*)" state$/) do |state|
  @the_task.reload
  expect(@the_task.state).to eq state
end

Then(/^the system "(.*)" a confirming text message with the "(.*)" state$/) do |maybe, next_state|
  if maybe == "sends"
    expect(NotifyUser.sms).to have_received(:create).with(hash_including(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: ENV['DEFAULT_USER_PHONE_NUMBER'],
      body: "Task \"#{@the_task.name}\" is #{next_state}!")
    )
  else
    expect(NotifyUser.sms).not_to have_received(:create)
  end
end

Then(/^the system does not send a confirming text message$/) do
  expect(NotifyUser.sms).to_not have_received(:create)
end
