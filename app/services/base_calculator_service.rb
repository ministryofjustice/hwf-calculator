# An abstract base class for all calculator services, used to define a common
# interface.
#
# All calculators can be called using 'call' on the class itself, which will return an instance
# with the results.
# The caller can then call @see available_help to determine if
# a decision has been made by this calculator.
#
# The reasons for the decisions are given in the @see messages array, which contain a list
# of hashes looking like this
#
# @example A messages hash
#
#   { key: :i18n_key, source: :underscored_name_of_calculator, classification: :positive }
#
# The caller can then use I18n translation to convert these into text to present to the user.
# The classification is used to group types of messages for presentation (i.e. styling)
#
# So, if we had a sub class like this
#
# @example Defining a calculator service
#   class MyCalculatorService < BaseCalculatorService
#     def call
#       do_something
#       self.available_help = :full
#       messages << { key: :likely, source: :my_calculator, classification: :positive }
#       self
#     end
#   end
#
# Then we could could call it like this
#
# @exammple Calling the above calculator service
#   inputs = {
#     my_input_1: 12,
#     my_input_2: 24
#   }
#   result = MyCalculatorService.call(inputs)
#   result.available_help  # => :full
#   result.messages # => [{ key: :likely, source: :my_calculator, classification: :positive}]
#
# @abstract
class BaseCalculatorService
  attr_reader :messages, :available_help, :remission

  # @!attribute [r] available_help
  #   @return [Symbol] The type of help available :none, :partial, :full or :undecided
  # @!attribute [r] remission
  #   @return [Float] The amount of remission, only valid if available_help is :partial

  # Perform the calculation
  # @param [Hash] inputs The inputs (with symbolized keys) for the calculator
  # @return [BaseCalculatorService] An instance which will be a base calculator service or a sub class
  def self.call(inputs)
    new(inputs).call
  end

  # An identifier for use by the calculation service to store results against
  # @return [Symbol] The identifier - usually derived from the class name
  def self.identifier
    name.demodulize.gsub(/CalculatorService$/, '').underscore.to_sym
  end

  # @private
  # Not expected to be used directly - use the class .call method instead
  def initialize(inputs)
    self.inputs = inputs
    self.messages = []
    self.available_help = :undecided
    self.final_decision = false
  end

  # @private
  # Not expected to be used directly - use the class.call method instead. Performs the calculation
  def call
    raise 'Not Implemented'
  end

  # Indicates if the inputs were all valid
  #
  # @return [Boolean] If true, all inputs were valid, else false
  def valid?
    raise 'Not Implemented'
  end

  # Indicates a final decision has been made
  # The calculator engine need not bother with any more sub engines as they are not required
  # @return [Boolean] If true, this calculator has said final decision made
  def final_decision?
    final_decision
  end

  private

  attr_accessor :inputs, :final_decision
  attr_writer :messages, :available_help, :remission
end
