@focus @domain @api
Feature: Creating tasks

	In order to track the work that I need to do
	As a user
	I want to add a new task to a project

	Rules:
	- Name and description are required
	- Created tasks should default to the "todo" state

	Background:
		Given a project:
			| ID          | 54f8419c-3f22-4cba-b194-5f8b4727ccfd |

	Scenario:  Creating a task with required fields
	  When I create a task with:
	  	| NAME           | Sample Task             |
	  	| DESCRIPTION    | This is a sample task.  |
	  	| PROJECT ID     |  54f8419c-3f22-4cba-b194-5f8b4727ccfd |
    Then the system has the tasks:
	  	| PROJECT ID                           | NAME        | DESCRIPTION             |  STATE  |
	    | 54f8419c-3f22-4cba-b194-5f8b4727ccfd | Sample Task | This is a sample task.  |  todo   |

	
	#TODO: Refactor using ScenarioOutline

	Scenario:  Trying to create a task without a name
		When I try to create a task with:
			| DESCRIPTION    | This is a sample task.                |
	  	| PROJECT ID     |  54f8419c-3f22-4cba-b194-5f8b4727ccfd |
		Then the system has 0 tasks
		And I get the error "Name can't be blank"

	Scenario:  Trying to create a task without a description
		When I try to create a task with:
			| NAME           | Sample Task                           |
			| PROJECT ID     |  54f8419c-3f22-4cba-b194-5f8b4727ccfd |
		Then the system has 0 tasks
		And I get the error "Description can't be blank"		
