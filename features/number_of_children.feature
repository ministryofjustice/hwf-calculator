@e2e
@javascript

Feature: Number of children page

Background: Number of children page
  Given I am Claude and partner
  And I am on the number of children page

Scenario: Successfully submits my number of children
  When I successfully submit my number of children
  Then on the next page our number of children has been added to previous answers

Scenario: Children who might affect your claim
  When I click on children who might affect your claim
  Then I should see the copy for children who might affect your claim

Scenario: Displays number of children error message
  When I click next without submitting my number of children
  Then I should see the number of children error message

Scenario: Change previous answer
  When I click on change for marital status
  Then I should be taken back to the marital status page
  And I should see my other previous answers have been saved
  