require_relative 'question_numeric'
module Calculator
  module Test
    class TotalIncomeQuestionSection < QuestionNumericSection
      section :help_section, QuestionHelpSection, :help_section_labelled, 'What to include as income'

      # Validates that the guidance text is as expected
      # @param [String, Array[String]] text_or_array Either a single string to (partially) match or an
      #  array of strings which will be joined by a CR.  Note that whitespace should not be important,
      # nor html structure etc..
      # @raise [Capybara::ExpectationNotMet] if the assertion hasn't succeeded during wait time
      def validate_guidance(text_or_array)
        strings = Array(text_or_array)
        help_section.assert_text(strings.join("\n"))
      end

      def toggle_help
        help_section.toggle
      end

      # rubocop:disable Style/PredicateName
      def has_no_help_text?
        help_section.help_text_collapsed?
      end

      def has_help_text?
        help_section.help_text_expanded?
      end
      # rubocop:enable Style/PredicateName

      delegate :wait_for_help_text, to: :help_section

      delegate :wait_for_no_help_text, to: :help_section
    end
  end
end