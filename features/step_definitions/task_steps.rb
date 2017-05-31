Given(/^(\d+) tasks for project "(.*)"$/) do |count, project_id|
  d.given_tasks count: count, project_id: project_id
end