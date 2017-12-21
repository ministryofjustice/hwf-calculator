# Used to find a form class for a given field from the calculation input data
#
# @example Finding a form
#
# CalculationFormService.for(:marital_status) # => MaritalStatusForm
#
class CalculationFormService
  FORM_CLASSES = {
    nil => NilForm,
    marital_status: MaritalStatusForm,
    fee: FeeForm,
    date_of_birth: DateOfBirthForm,
    disposable_capital: DisposableCapitalForm,
    benefits_received: BenefitsReceivedForm,
    number_of_children: NumberOfChildrenForm

  }.freeze

  # Returns a form class for the given form symbol
  #
  # @param [Symbol, Nil] form The form symbol or nil
  #
  # @return [NilForm,MaritalStatusForm,FeeForm,DateOfBirthForm,
  #   DisposableCapitalForm,BenefitsReceivedForm,NumberOfChildrenForm] The form found
  # @raise [ArgumentError] If the form specified was not found
  def self.for(form)
    klass = FORM_CLASSES[form]
    raise ArgumentError, "Unknown form class for '#{form}'" if klass.nil?
    klass
  end
end
