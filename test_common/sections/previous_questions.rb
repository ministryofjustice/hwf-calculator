require_relative '../messaging'
require_relative './previous_question'
module Calculator
  module Test
    module PreviousQuestionsSection
      extend ActiveSupport::Concern
      include BaseSection
      ALL_QUESTIONS = [:marital_status, :court_fee, :disposable_capital, :income_benefits].freeze
      include ::Calculator::Test::I18n


      included do
        scope = @i18n_scope
        section :marital_status, :calculator_previous_question, t("hwf_components.previous_questions.marital_status.label") do
          @i18n_scope = "#{scope}.marital_status"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :court_fee, :calculator_previous_question, t('hwf_components.previous_questions.court_fee.label') do
          @i18n_scope = "#{scope}.court_fee"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :date_of_birth, :calculator_previous_question, t('hwf_components.previous_questions.date_of_birth.label') do
          @i18n_scope = "#{scope}.date_of_birth"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :partner_date_of_birth, :calculator_previous_question, t('hwf_components.previous_questions.partner_date_of_birth.label') do
          @i18n_scope = "#{scope}.partner_date_of_birth"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :disposable_capital, :calculator_previous_question, t('hwf_components.previous_questions.disposable_capital.label') do
          @i18n_scope = "#{scope}.disposable_capital"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :income_benefits, :calculator_previous_question, t('hwf_components.previous_questions.income_benefits.label') do
          @i18n_scope = "#{scope}.income_benefits"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :number_of_children, :calculator_previous_question, t('hwf_components.previous_questions.number_of_children.label') do
          @i18n_scope = "#{scope}.number_of_children"
          include ::Calculator::Test::PreviousQuestionSection
        end
        section :total_income, :calculator_previous_question, t('hwf_components.previous_questions.total_income.label') do
          @i18n_scope = "#{scope}.total_income"
          include ::Calculator::Test::PreviousQuestionSection
        end
      end

      def disabled?
        ALL_QUESTIONS.all? {|q| send(q).disabled?}
      end
    end
  end
end

