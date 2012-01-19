When /^I have valid okcupid credentials$/ do
  user = valid_user.merge(username: 'match-machine', okcupid_pass: 'password')
  @user = user
end

When /^I have invalid okcupid credentials$/ do
  user = valid_user.merge(username: 'incorrect-username', okcupid_pass: 'incorrect_password')
  @user = user
end

