Feature: Dashboard to display various capture_api information modules
  In order to maintain awareness of all things Capture
  As a member of the Capture team
  I want to have a dashboard to review current Capture state

  @javascript
  Scenario: Dashboard displays LAX capture_api health check module
    When I visit the dashboard page as an admin
    Then I should see the LAX capture_api health check module
    And I should see the LAX health check dependencies

  @javascript
  Scenario: Dashboard displays LAX Resque module
    When I visit the dashboard page as an admin
    Then I should see the LAX Capture Resque module

  @javascript
  Scenario: Dashboard displays IAD capture_api health check module
    When I visit the dashboard page as an admin
    Then I should see the IAD capture_api health check module
    And I should see the IAD health check dependencies

  @javascript
  Scenario: Dashboard displays IAD Resque module
    When I visit the dashboard page as an admin
    Then I should see the IAD Capture Resque module

  @javascript
  Scenario: Dashboard displays Airbrake module
    When I visit the dashboard page as an admin
    Then I should see the Capture Airbrake module

  @javascript
  Scenario: Dashboard displays links to internal reports
    When I visit the dashboard page as an admin
    Then I see the Capture Internal Reporting module
    And I see links to the internal reports

  Scenario: Not authorized
    When I visit the dashboard page
    Then the dashboard page request status should be 401
