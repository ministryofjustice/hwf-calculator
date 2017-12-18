require 'rails_helper'
RSpec.describe CalculationService do
  subject(:service) { described_class }

  # The fake calculators that are used by most examples.
  # As standard, we setup 3 calculators but this is just an arbitrary number.
  # The service can handle any number of calculators
  shared_context 'fake calculators' do
    let(:calculator_1_class) { class_spy(BaseCalculatorService, 'Calculator 1 class') }
    let(:calculator_2_class) { class_spy(BaseCalculatorService, 'Calculator 2 class') }
    let(:calculator_3_class) { class_spy(BaseCalculatorService, 'Calculator 3 class') }

    let(:calculator_1) do
      instance_spy(BaseCalculatorService, 'Calculator 1', help_not_available?: false, help_available?: false, valid?: true, messages: [])
    end

    let(:calculator_2) do
      instance_spy(BaseCalculatorService, 'Calculator 2', help_not_available?: false, help_available?: false, valid?: true, messages: [])
    end

    let(:calculator_3) do
      instance_spy(BaseCalculatorService, 'Calculator 3', help_not_available?: false, help_available?: false, valid?: true, messages: [])
    end

    let(:calculators) { [calculator_1_class, calculator_2_class, calculator_3_class] }

    # The calculators must be called using the simple call method on the class
    # Whilst an instance can be created and the call method used on that, it is
    # preferred that we don't do this.
    before do
      allow(calculator_1_class).to receive(:call).with(inputs).and_return(calculator_1)
      allow(calculator_2_class).to receive(:call).with(inputs).and_return(calculator_2)
      allow(calculator_3_class).to receive(:call).with(inputs).and_return(calculator_3)
    end
  end

  describe '#call' do
    context 'with fake calculators' do
      let(:inputs) do
        {
          disposable_capital: 1000
        }
      end
      include_context 'fake calculators'
      it 'calls calculator 1' do
        # Act
        service.call(inputs, calculators: calculators)

        # Assert
        expect(calculator_1_class).to have_received(:call).with(inputs)
      end

      it 'calls calculator 2' do
        # Act
        service.call(inputs, calculators: calculators)

        # Assert
        expect(calculator_2_class).to have_received(:call).with(inputs)
      end

      it 'calls calculator 3' do
        # Act
        service.call(inputs, calculators: calculators)

        # Assert
        expect(calculator_3_class).to have_received(:call).with(inputs)
      end

      it 'returns an instance of CalculationService' do
        # Act and Assert
        expect(service.call(inputs, calculators: calculators)).to be_a described_class
      end

      context 'with calculation failures' do
        it 'prevents calculator 2 being called if calculator 1 fails' do
          # Arrange
          failure_reasons = [:reason1, :reason2]
          allow(calculator_1).to receive(:help_not_available?).and_return true
          allow(calculator_1).to receive(:messages).and_return failure_reasons

          # Act
          service.call(inputs, calculators: calculators)

          # Assert
          expect(calculator_2_class).not_to(have_received(:call))
        end

        it 'prevents calculator 3 being called if calculator 1 fails' do
          # Act
          failure_reasons = [:reason1, :reason2]
          allow(calculator_1).to receive(:help_not_available?).and_return true
          allow(calculator_1).to receive(:messages).and_return failure_reasons

          # Arrange
          service.call(inputs, calculators: calculators)

          # Assert
          expect(calculator_3_class).not_to(have_received(:call))
        end
      end

      context 'order of calculators called' do
        it 'calls the calculators in order' do
          # Arrange
          calculators_called = []
          allow(calculator_1_class).to receive(:call).with(inputs) do
            calculators_called << 1
            calculator_1
          end
          allow(calculator_2_class).to receive(:call).with(inputs) do
            calculators_called << 2
            calculator_2
          end
          allow(calculator_3_class).to receive(:call).with(inputs) do
            calculators_called << 3
            calculator_3
          end

          # Act
          service.call(inputs, calculators: calculators)

          # Assert
          expect(calculators_called).to eql [1, 2, 3]
        end

        it 'does not call the second calculator if the first had invalid inputs' do
          # Arrange
          calculators_called = []
          allow(calculator_1_class).to receive(:call).with(inputs) do
            calculators_called << 1
            allow(calculator_1).to receive(:valid?).and_return false
            throw :invalid_inputs, calculator_1
          end
          allow(calculator_2_class).to receive(:call).with(inputs) do
            calculators_called << 2
            calculator_2
          end
          allow(calculator_3_class).to receive(:call).with(inputs) do
            calculators_called << 3
            calculator_3
          end

          # Act
          service.call(inputs, calculators: calculators)

          # Assert
          expect(calculators_called).to eql [1]

        end
      end
    end

    context 'with pre configured calculators' do
      let(:inputs) do
        {
          disposable_capital: 1000
        }
      end

      it 'calls the disposable income calculator' do
        # Arrange
        kls = class_double(DisposableCapitalCalculatorService).as_stubbed_const
        fake_calculation = instance_double(BaseCalculatorService, 'Fake calculation', help_not_available?: false, help_available?: false, valid?: true)
        allow(kls).to receive(:call).with(inputs).and_return fake_calculation

        # Act
        service.call(inputs)

        # Assert
        expect(kls).to have_received(:call).with(inputs)
      end
    end
  end

  describe '#help_available?' do
    let(:inputs) do
      {
        disposable_capital: 1000
      }
    end
    include_context 'fake calculators'

    it 'has help available if calculator 1 says it is available' do
      # Arrange
      allow(calculator_1).to receive(:help_available?).and_return true
      allow(calculator_1).to receive(:messages).and_return []

      # Act and Assert
      expect(service.call(inputs, calculators: calculators)).to have_attributes help_available?: true
    end

    it 'provides access to messages' do
      # Arrange
      reasons = [:reason1, :reason2]
      allow(calculator_1).to receive(:help_not_available?).and_return false
      allow(calculator_1).to receive(:help_available?).and_return true
      allow(calculator_1).to receive(:messages).and_return reasons

      # Act and Assert
      expect(service.call(inputs, calculators: calculators)).to have_attributes messages: reasons
    end
  end

  describe '#help_not_available?' do
    let(:inputs) do
      {
        disposable_capital: 1000
      }
    end
    include_context 'fake calculators'

    it 'returns true if help_not_available? returns true from fake calculator' do
      # Arrange
      allow(calculator_1).to receive(:help_not_available?).and_return true

      # Act and Assert
      expect(service.call(inputs, calculators: calculators)).to have_attributes help_not_available?: true
    end

    it 'returns false if help_not_available? returns false from all fake calculators' do
      # Arrange
      allow(calculator_1).to receive(:help_not_available?).and_return false
      allow(calculator_1).to receive(:help_not_available?).and_return false
      allow(calculator_1).to receive(:help_not_available?).and_return false

      # Act and Assert
      expect(service.call(inputs, calculators: calculators)).to have_attributes help_not_available?: false
    end
  end

  describe '#fields_required' do
    let(:inputs) do
      {
        disposable_capital: 1000
      }
    end
    include_context 'fake calculators'

    it 'returns any fields not provided in the input in the correct order' do

      # Act and Assert
      expect(service.call(inputs, calculators: calculators)).to have_attributes fields_required: [:marital_status, :fee, :date_of_birth, :benefits_received, :number_of_children, :total_income]
    end
  end

  describe '#required_fields_affecting_likelyhood' do
    let(:inputs) do
      {
        disposable_capital: 1000
      }
    end
    include_context 'fake calculators'

    it 'returns any fields not provided that will affect the likelyhood and not those that just affect the amount' do

      # Act and Assert
      expect(service.call(inputs, calculators: calculators)).to have_attributes required_fields_affecting_likelyhood: [:date_of_birth, :benefits_received, :total_income]
    end
  end

  describe '#to_h' do
    let(:inputs) do
      {
        disposable_capital: 1000
      }
    end
    include_context 'fake calculators'

    it 'returns the correct hash' do
      # Arrange
      subject = service.call(inputs, calculators: calculators)

      # Act and Assert
      expect(subject.to_h).to include inputs: a_hash_including(inputs),
                                      should_get_help: false,
                                      should_not_get_help: false,
                                      fields_required: instance_of(Array),
                                      required_fields_affecting_likelyhood: instance_of(Array),
                                      messages: []
    end
  end
end
