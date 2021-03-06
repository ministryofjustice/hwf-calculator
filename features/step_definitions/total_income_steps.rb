Given(/^I am on the total income page$/) do
  answer_up_to(:total_income)
end

When(/^I successfully submit (?:my|our) total income$/) do
  answer_total_income_question
end

Then(/^on the next page (?:my|our) total income has been added to previous answers$/) do
  expect(full_remission_page.previous_answers).to have_marital_status
  expect(full_remission_page.previous_answers).to have_court_fee
  expect(full_remission_page.previous_answers).to have_date_of_birth
  expect(full_remission_page.previous_answers).to have_partner_date_of_birth
  expect(full_remission_page.previous_answers).to have_income_benefits
  expect(full_remission_page.previous_answers).to have_number_of_children
  expect(full_remission_page.previous_answers).to have_total_income
end

Then(/^I should see that I should be eligible for full remission$/) do
  expect(full_remission_page).to be_valid_for_final_positive_message(user)
end

Then(/^I should see that I should be eligible for part remission where I need to pay (\d*)$/) do |citizen_pays|
  expect(partial_remission_page).to be_valid_for_final_partial_message(user, citizen_pays: citizen_pays.to_i)
end

Then(/^I should see that I am not eligible for remission$/) do
  expect(not_eligible_page).to be_displayed
end

When(/^I click on what to include as income$/) do
  total_income_page.toggle_guidance
end

Then(/^I should see the copy for what to include as income$/) do
  expect(total_income_page.validate_guidance).to be true
end

When(/^I click next without submitting my total income$/) do
  total_income_page.next
end

Then(/^I should see the total income error message$/) do
  expect(total_income_page.total_income).to have_error_non_numeric
end

When(/^I change my answer for my court and tribunal fee to £1000$/) do
  total_income_page.previous_answers.court_fee.navigate_to
  court_fee_page.fee.set(1000)
  court_fee_page.next
end

Then(/^I should see that I am now unlikely to get help with fees$/) do
  expect(not_eligible_page).to be_displayed
end

Then(/^I should see my answer for court and tribunal fee has been changed to £1000$/) do
  expect(not_eligible_page.previous_answers.court_fee).to have_answered(1000)
end
