require 'blank_date'
require 'invalid_date'
# The strict date does not take any rubbish.  It does not convert strings into year zero
# for example.  So, allows for much better validation.
# It can also return an @see InvalidDate instance or a @see BlankDate instance if the date is either blank
# or invalid.  This is then used by the custom validators.
# This means that any code using the value can rely on it being a date or nil.
# Any code that needs to display the invalid values can still call 'day', 'month' or 'year' on it etc..
class StrictDateType < ActiveModel::Type::Value
  def initialize(invalid_date_class: InvalidDate, blank_date_class: BlankDate, **args)
    self.invalid_date_class = invalid_date_class
    self.blank_date_class = blank_date_class
    super(*args)
  end

  # Casts the value to a date
  # @param [Object] value The value to cast to a date or nil
  # @return [Date,Nil,InvalidDate,BlankDate] The cast date or nil if nil was given
  def cast(value)
    if value.nil? || value.is_a?(Date)
      value
    else
      raise "The strict date type must be presented with a hash containing day, month and year" unless value.is_a?(Hash)
      cast_value(value.symbolize_keys)
    end
  end

  private

  def cast_value(value)
    if [value[:year], value[:month], value[:day]].all?(&:nil?)
      nil
    elsif value.slice(:day, :month, :year).values.any?(&:blank?)
      blank_date_class.new
    else
      create_date value[:year], value[:month], value[:day]
    end
  end

  def create_date(year, month, day)
    # This might look odd - its a way to convert string to integer, raising an error if it cannot be converted
    # as to_i returns 0 if it fails to convert to Integer('09') fails because it things its octal
    Date.new Float(year).to_i, Float(month).to_i, Float(day).to_i
  rescue ArgumentError
    invalid_date_class.new year, month, day
  end

  attr_accessor :invalid_date_class, :blank_date_class
end