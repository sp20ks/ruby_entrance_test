# frozen_string_literal: true

require'./periods'

RSpec.describe Periods do
  include Periods
  # Тесты для функции valid?
  describe 'periods_valid?' do
    it 'should return true' do
      expect(Periods.chain_correct?('16.07.2023', ["2023", "2024", "2025"])).to eq(true)

      expect(Periods.chain_correct?('31.01.2023', ["2023M1", "2023M2", "2023M3"])).to eq(true)

      expect(Periods.chain_correct?('04.06.1976', ["1976M6D4", "1976M6D5", "1976M6D6"])).to eq(true)

      expect(Periods.chain_correct?('30.01.2023', ["2023M1", "2023M2", "2023M3D30"])).to eq(true)

      expect(Periods.chain_correct?('30.01.2020', ["2020M1", "2020", "2021", "2022", "2023", "2024M2", "2024M3D30"])).to eq(true)
    end

    it 'should return false' do
      expect(Periods.chain_correct?('24.04.2023', ["2023", "2025", "2026"])).to eq(false)

      expect(Periods.chain_correct?('10.01.2023', ["2023M1", "2023M3", "2023M4"])).to eq(false)

      expect(Periods.chain_correct?('02.05.2023', ["2023M5D2", "2023M5D3", "2023M5D5"])).to eq(false)

      expect(Periods.chain_correct?('31.01.2023', ["2023M1", "2023M2", "2023M3D30"])).to eq(false)

      expect(Periods.chain_correct?('30.01.2020', ["2020M1", "2020", "2021", "2022", "2023", "2024M2", "2024M3D29"])).to eq(false)
    end
  end
end
