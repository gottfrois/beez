require 'beez/cli'

RSpec.describe Beez::CLI do

  subject { described_class.instance }

  describe '#parse' do
    describe 'env' do
      it 'accepts with -e' do
        subject.parse(%w[beez -e staging -r ./spec/dummy/])
        expect(Beez.config.env).to eq("staging")
      end
    end

    describe 'require' do
      it 'accepts with -r' do
        subject.parse(%w[beez -r ./spec/dummy/])
        expect(Beez.config.require).to eq("./spec/dummy/")
      end
    end

    describe 'timeout' do
      it 'accepts with -t' do
        subject.parse(%w[beez -t 5 -r ./spec/dummy/])
        expect(Beez.config.timeout).to eq(5)
      end

      it 'raises when provided value is not a positive integer' do
        expect {
          subject.parse(%w[beez -t 0 -r ./spec/dummy/])
        }.to raise_error(ArgumentError)
      end
    end

    describe 'verbose' do
      it 'accepts with -v' do
        subject.parse(%w[beez -v -r ./spec/dummy/])
        expect(Beez.logger.level).to eq(Logger::DEBUG)
      end
    end
  end
end
