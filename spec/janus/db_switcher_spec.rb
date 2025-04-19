# frozen_string_literal: true

require 'spec_helper'
require 'janus/db_switcher'

RSpec.describe Janus::DbSwitcher do
  describe '.switch' do
    context 'when database_name blank' do
      it 'raises SwitchError if database_name is empty string' do
        expect { described_class.switch('') }.to raise_error(Janus::SwitchError, /Empty database_name/)
      end
    end

    context 'when current equals database_name' do
      it 'returns true without changing connection' do
        allow(described_class).to receive(:current).and_return('db1')
        expect(described_class.switch('db1')).to be true
      end
    end

    context 'when establish_connection fails' do
      it 'raises SwitchError with original message' do
        allow(described_class).to receive(:current).and_return('other')
        allow(ActiveRecord::Base.connection_pool).to receive(:disconnect!).and_raise(StandardError.new('fail'))
        expect { described_class.switch('db1') }.to raise_error(Janus::SwitchError, /fail/)
      end
    end

    context 'when switch succeeds' do
      let(:sequence) { [] }

      before do
        allow(described_class).to receive(:current) { sequence.empty? ? ((sequence << :other) && 'old_db') : 'new_db' }
        allow(ActiveRecord::Base.connection_pool).to receive(:disconnect!) { sequence << :disconnected }
        allow(ActiveRecord::Base).to receive(:establish_connection) { sequence << :established }
      end

      it 'disconnects when switching' do
        described_class.switch('new_db')
        expect(sequence).to include(:disconnected)
      end

      it 'establishes new connection when switching' do
        described_class.switch('new_db')
        expect(sequence).to include(:established)
      end

      it 'returns true' do
        allow(described_class).to receive(:current).and_return('new_db')
        allow(ActiveRecord::Base.connection_pool).to receive(:disconnect!)
        allow(ActiveRecord::Base).to receive(:establish_connection)
        expect(described_class.switch('new_db')).to be true
      end
    end
  end
end
