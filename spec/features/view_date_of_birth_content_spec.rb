require 'rails_helper'
# This feature represents the acceptance criteria defined in RST-727
RSpec.describe 'View date of birth content', type: :feature, js: true do
  # Feature: Date of birth Page Content
  #
  #
  #
  # Scenario: View date of birth Heading, Question and Hint text (Revised)
  #               Given I am on the date of birth page
  #               When I view the Heading, question and Hint text
  #               Then Heading reads "Find out if you could get help with fees"
  #               And question reads "What is your date of birth?"
  #               And Hint text reads "If you are over 61 years of age (and don't have much in savings), you may be able to get help with your fee"
  scenario 'View date of birth Heading, Question and Hint text' do
    # Arrange
    given_i_am(:john)

    # Act
    answer_questions_up_to_date_of_birth

    # Assert
    aggregate_failures 'Validating content' do
      expect(date_of_birth_page.heading).to be_present
      expect(date_of_birth_page.date_of_birth).to be_present
      expect(date_of_birth_page.date_of_birth.hint_with_text(messaging.t('hwf_pages.date_of_birth.hint'))).to be_present
    end
  end
  #
  #
  # Date of birth Heading:
  # Find out if you could get help with fees
  #
  #
  #
  # Page Question:
  # What is your date of birth
  #
  #
  #
  # Background Notes:
  # Single:
  #
  # If you are over 61 years of age (and don’t have much in savings), you may be able to get help with your fee.
  #
  # Married or living with someone:
  #
  # If you or your partner are over 61 years of age (and don’t have much in savings), you may be able to get help with your fee
  #
end