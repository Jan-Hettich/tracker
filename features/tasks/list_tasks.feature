@domain @api
Feature: Listing tasks

  In order to track the work that I need to do
  As a user
  I want to see a list of all tasks for a given project

  Note:  The paging features of the list are thoroughly tested in the context of projects

  Background:
    Given a project:
      | ID          | 54f8419c-3f22-4cba-b194-5f8b4727ccfd |
      | NAME        | Valid project name       

  Scenario: No parameters are specified and there are 5 tasks                |
    Given 5 tasks for project 4f8419c-3f22-4cba-b194-5f8b4727ccfd 
    When I request the tasks list for project 54f8419c-3f22-4cba-b194-5f8b4727ccfd
    Then I get 5 tasks back

  Scenario: Verifying the format shape
    Given a task:
      | ID          | 3f53e6a0-edc8-4b81-baa6-06b5740f88c1 |
      | PROJECT ID  | 54f8419c-3f22-4cba-b194-5f8b4727ccfd |
      | NAME        | Sample Task                          |
      | DESCRIPTION | A small sample task                  |  
    When I request the tasks list for project 54f8419c-3f22-4cba-b194-5f8b4727ccfd
    Then I get the data:
      """
      {
        tasks: [
          {
            id: '3f53e6a0-edc8-4b81-baa6-06b5740f88c1',
            project_id: '54f8419c-3f22-4cba-b194-5f8b4727ccfd'
            name: 'Sample Task',
            description: 'A small sample task',
            state: 'todo'
          }
        ],
        count: 1,
        current_page_number: 1,
        total_page_count: 1
      }
      """