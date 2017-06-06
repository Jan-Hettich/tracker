@domain @api
Feature:  Getting a task

  In order to track the work that I need to do
  As a user
  I want to get a task by its id

  Scenario: Getting a task by its id
    Given a project:
      | ID          | 54f8419c-3f22-4cba-b194-5f8b4727ccfd |
      | NAME        | Valid project name                   |
    And a task:
      | ID          | 3f53e6a0-edc8-4b81-baa6-06b5740f88c1 |
      | PROJECT ID  | 54f8419c-3f22-4cba-b194-5f8b4727ccfd |
      | NAME        | Sample Task                          |
      | DESCRIPTION | A small sample task       	         |
    When I request the task by id "3f53e6a0-edc8-4b81-baa6-06b5740f88c1"
    Then I get the data:
      """
      {
        id: '3f53e6a0-edc8-4b81-baa6-06b5740f88c1',
        project_id: '54f8419c-3f22-4cba-b194-5f8b4727ccfd',
        name: 'Sample Task',
        description: 'A small sample task',
        state: 'todo'
      }
      """
