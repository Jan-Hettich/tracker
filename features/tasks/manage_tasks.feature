@domain @api
Feature: Managing tasks

  In order to track the work that I need to do
  As a user
  I want to manage the task states
  I want to be notified via a text meessage when the task is complete

  Rules:
  - task states:  todo (default), in-progress, done
  - valid state transitions:  todo <=> in-progress, in-progress => done
  
  Scenario Outline:  Allowed state transitions
    Given a task:
      | STATE       | <INITIAL>   |
    When I transition the task to the "<NEXT>" state
    Then the task is in the "<NEXT>" state
    And the system "<MAYBE_SENDS>" a confirming text message with the "<NEXT>" state

    Examples:
      | INITIAL     | NEXT        | MAYBE_SENDS   |
      | todo        | in-progress | does not send |
      | in-progress | todo        | does not send |
      | in-progress | done        | sends         |

  Scenario Outline:  Forbidden state transitions
    Given a task:
      | STATE       | <INITIAL>   |
    When I try to transition the task to the "<NEXT>" state
    Then the task is in the "<INITIAL>" state
    And I get the error "State transition invalid!"
    And the system does not send a confirming text message

    Examples:
      | INITIAL     | NEXT        |
      | todo        | done        |
      | done        | todo        |
      | done        | in-progress |

