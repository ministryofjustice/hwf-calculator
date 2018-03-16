require 'rails_helper'
RSpec.describe 'View partial remission page' do
  scenario 'Verify no caching on partial remission page using NON JS BROWSER', js: false do
    # Arrange
    given_i_am(:oliver)
    answer_up_to(:total_income)

    # Act
    answer_total_income_question

    # Assert
    expect(partial_remission_page).to have_no_cache
  end
end
