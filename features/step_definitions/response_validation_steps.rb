include ActiveSupport::NumberHelper
Then(/^the calculator response should be "([^"]*)"$/) do |msg|
  expect(any_calculator_page.positive_feedback_message_saying(msg)).to be_present
end

And(/^savings and investment question, answer appended to the calculator Previous answers section$/) do
  expect(any_calculator_page.previous_answers.disposable_capital.answer.text).to eql number_to_currency(user.disposable_capital, precision: 0, unit: '£')
end
