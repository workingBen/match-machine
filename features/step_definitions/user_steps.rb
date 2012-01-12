### UTILITY METHODS ###
def valid_user
  @user ||= { :name => "Testy McUserton", :email => "testy@userton.com",
    :password => "please", :password_confirmation => "please", username: 'match-machine', okcupid_pass: 'password'}
end

def sign_up user
  visit '/users/sign_up'
  fill_in "user_email", :with => user[:email]
  fill_in "user_username", :with => user[:username]
  fill_in "user_okcupid_pass", :with => user[:okcupid_pass]
  fill_in "user_password", :with => user[:password]
  fill_in "user_password_confirmation", :with => user[:password_confirmation]
  click_button "Sign up"
end

def sign_in user
  visit '/users/sign_in'
  fill_in "user_email", :with => user[:email]
  fill_in "user_password", :with => user[:password]
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/users/sign_out'
end

Given /^I am logged in$/ do
  sign_up valid_user
end

Given /^I exist as a user$/ do
  sign_up valid_user
  visit '/users/sign_out'
end

Given /^I do not exist as a user$/ do
  User.find(:first, :conditions => { :email => valid_user[:email] }).should be_nil
  visit '/users/sign_out'
end

### WHEN ###
When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
  sign_up valid_user
end

When /^I sign up with an invalid email$/ do
  user = valid_user.merge(:email => "notanemail")
  sign_up user
end

When /^I sign up without a confirmed password$/ do
  user = valid_user.merge(:password_confirmation => "")
  sign_up user
end

When /^I sign up without a password$/ do
  user = valid_user.merge(:password => "")
  sign_up user
end

When /^I sign up with a mismatched password confirmation$/ do
  user = valid_user.merge(:password_confirmation => "please123")
  sign_up user
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong password$/ do
  user = valid_user.merge(:password => "wrongpass")
  sign_in user
end

When /^I sign in with valid credentials$/ do
  sign_in valid_user
end

When /^I edit my account details$/ do
  click_link "Edit account"
  fill_in "user_username", :with => "newusername"
  fill_in "user_current_password", :with => valid_user[:password]
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/'
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_css "img[alt=Logout]"
  page.should_not have_css "img[alt='Sign up']"
  page.should_not have_css "img[alt=Login]"
end

Then /^I should be signed out$/ do
  page.should have_css "img[alt='Sign up']"
  page.should have_css "img[alt=Login]"
  page.should_not have_css "img[alt=Logout]"
end

Then /^I should see a succesfull sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out"
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  page.should have_content valid_user[:name]
end

