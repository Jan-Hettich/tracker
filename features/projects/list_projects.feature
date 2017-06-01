@domain @api
Feature: Listing projects

  Rules:
  - if a negative page is requested, an error is thrown
  - if a page that is too high is requested, the last page is returned
  - if a negative page_size is requested, the default size is used


  Scenario: No parameters are specified and there are 26 projects
    Given 26 projects
    When I request the projects list
    Then I get 25 projects back
    And the current page is 1
    And the total pages is 2
    And the total results is 26


  Scenario: Specifying parameters for the last page
    Given 3 projects
    When I request the projects list with parameters:
      | PAGE_SIZE | 2 |
      | PAGE      | 2 |
    Then I get 1 project back
    And the current page is 2
    And the total pages is 2
    And the total results is 3


  Scenario: The specified page is outside of the acceptable range
    Given 3 projects
    When I request the projects list with parameters:
      | PAGE_SIZE | 2 |
      | PAGE      | 5 |
    Then I get 1 project back
    And the current page is 2
    And the total pages is 2
    And the total results is 3


  Scenario: The specified page size is greater than the number of projects
    Given 2 projects
    When I request the projects list with parameters:
      | PAGE_SIZE | 10 |
      | PAGE      | 1  |
    Then I get 2 projects back
    And the current page is 1
    And the total pages is 1
    And the total results is 2


  Scenario: The specified page is negative
    Given 2 projects
    When I request the projects list with parameters:
      | PAGE | -1 |
    Then I get the error "Page cannot be <= 0"


  Scenario: Verifying the format shape
    Given a project:
      | ID          | 54f8419c-3f22-4cba-b194-5f8b4727ccfd |
      | NAME        | Sample Project                       |
      | DESCRIPTION | A small sample project               |
      | STATE       | active                               |
    When I request the projects list
    Then I get the data:
      """
      {
        projects: [
          {
            id: '54f8419c-3f22-4cba-b194-5f8b4727ccfd',
            name: 'Sample Project',
            description: 'A small sample project',
            state: 'active'
          }
        ],
        count: 1,
        current_page_number: 1,
        total_page_count: 1
      }
      """
