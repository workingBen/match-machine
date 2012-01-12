Feature: Okcupid Sign in on Machine Setup
  In order to get access to okcupid, we must do a sign in and retrieve the cookie used for authentication
  A user
  Should be able to sign in to okcupid so the machine can search with the user's account

    Scenario: User signs in with valid okcupid credentials
      Given I exist as a user
        And I am not logged in
      When I sign in with valid credentials
        And I have valid okcupid credentials
        And I am on the machine setup page
      Then I should see "Ready to run machine"

    Scenario: User signs in with invalid okcupid credentials
      Given I exist as a user
        And I am not logged in
      When I sign in with valid credentials
        And I have invalid okcupid credentials
        And I am on the machine setup page
      Then I should see "Okcupid Credentials are Invalid. Please fix them in Edit Account."

