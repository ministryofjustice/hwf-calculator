module Calculator
  module Test
    module En
      class CourtFeePage < BasePage
        set_url '/calculation/fee'
        section :fee, ::Calculator::Test::QuestionNumericSection, :calculator_question, 'How much is the court or tribunal fee you have to pay (or have paid within the last 3 months)?'
        element :next_button, :button, 'Next step'

        # Progress to the next page
        def next
          next_button.click
        end

        # Find an error matching the given text in the fee field
        #
        # @param [String] text The error message to match
        #
        # @return [Capybara::Node::Element] The node found
        # @raise [Capybara::ElementNotFound] If an error message could not be found
        def error_with_text(text)
          fee.error_with_text(text)
        end
      end
    end
  end
end
