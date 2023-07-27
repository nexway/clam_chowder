require './lib/clam_chowder.rb'
require 'tempfile'

def create_virus_file
  Tempfile.open('eicar.com', encoding: 'BINARY').tap do |file|
    # [note] - EICAR Test Virus
    # http://www.eicar.org/86-0-Intended-use.html
    file.write('X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*')
    file.rewind
  end
end

describe 'Scanner' do
  describe '.infected_stream?' do
    subject { ClamChowder::Scanner.infected_stream?(File::open(file_path)) }

    before do
      scan_mock = instance_double('::Clamd::Client')
      allow(scan_mock).to receive(:scan) { "#{file_path}: #{result}" }
      allow(::Clamd::Client).to receive(:new) { scan_mock }
    end

    context 'ウイルスが未検知の場合' do
      let(:file_path) { 'spec/fixtures/innocent.txt' }
      let(:result) { 'OK' }

      it { is_expected.to eq false }
    end

    context 'ウイルスが検知された場合' do
      let(:file)      { create_virus_file }
      let(:file_path) { file.path }
      let(:result) { 'TEST.VIRUS FOUND' }

      after { file.close }

      it { is_expected.to eq true }
    end

    context '検知/未検知以外の場合' do
      let(:file_path) { 'path/to/file' }
      let(:result) { 'Timeout' }

      specify 'ScanException 例外が発生すること' do
        expect { ClamChowder::Scanner.infected_stream?(file_path) }.to raise_error(ClamChowder::ScanException)
      end
    end
  end

  describe '#scan_io' do
    context 'Backend が clamd の場合' do
      before { ClamChowder.default_backend = :clamd }

      let(:scanner)     { ClamChowder::Scanner.new }
      let(:scan_result) { scanner.scan_io File::open(file_path) }

      before do
        scan_mock = instance_double('::Clamd::Client')
        allow(scan_mock).to receive(:scan) { "#{file_path}: #{scan_message}" }
        allow(::Clamd::Client).to receive(:new) { scan_mock }
      end

      context 'ウィルス未検知の場合' do
        let(:file_path) { 'spec/fixtures/innocent.txt' }
        let(:scan_message) { 'OK' }

        specify do
          expect(scan_result).to_not be_infected
        end
      end

      context 'ウィルス検知の場合' do
        let(:file)      { create_virus_file }
        let(:file_path) { file.path }
        let(:scan_message) { 'Eicar-Test-Signature FOUND' }

        after { file.close }

        specify do
          expect(scan_result).to be_infected
          expect(scan_result.virus_name.upcase).to include 'EICAR'
        end
      end

      context '検知/未検知以外の場合' do
        let(:file_path) { "/path/to/file" }
        let(:scan_message) { 'Timeout' }

        specify "例外が発生すること" do
          expect { ClamChowder::Scanner.new.scan_io(file_path) }.to raise_error(ClamChowder::ScanException)
        end
      end
    end

    context 'Backend が stub の場合' do
      before { ClamChowder.default_backend = :stub }

      let(:scanner)     { ClamChowder::Scanner.new }
      let(:scan_result) { scanner.scan_io File::open(file_path) }

      context 'ウィルス未検知の場合' do
        let(:file_path) { 'spec/fixtures/innocent.txt' }

        specify do
          expect(scan_result).to_not be_infected
        end
      end

      context 'ウィルス検知の場合' do
        let(:file) do
          Tempfile.open('stub_virus.txt', encoding: 'BINARY').tap do |file|
            file.write('virus')
            file.rewind
          end
        end
        let(:file_path) { file.path }

        after { file.close }

        specify do
          expect(scan_result).to be_infected
          expect(scan_result.virus_name).to eq 'stub-virus'
        end
      end

      context '検知/未検知以外の場合' do
        let(:file_path) { "/path/to/file" }

        specify "例外が発生すること" do
          expect { ClamChowder::Scanner.new.scan_io(file_path) }.to raise_error(ClamChowder::ScanException)
        end
      end
    end
  end
end
