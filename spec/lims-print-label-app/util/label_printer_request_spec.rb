require 'lims-print-label-app/util/label_printer_request'
require 'spec_helper'

module Lims::PrintLabelApp
  module Util
    describe LabelPrinterRequest do
      before do
        LabelPrinterRequest.any_instance.stub(:get) do
          YAML.load(get_file_as_string(File.join('spec', 'test_files','label_printers.json')))
        end
        LabelPrinterRequest.any_instance.stub(:url_for) do
          dummy_url
        end
      end

      let(:dummy_url) { "http://example.com/"}
      subject { LabelPrinterRequest.new(dummy_url) }
      let(:printer_name) { "d304bc-test" }

      context "gets a uuid by name" do
        it {
          uuid = subject.uuid_by_name(printer_name)
          uuid.should be_a_kind_of(String)
          uuid.should match(/^([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})?/)
        }
      end

      context "checks a valid label printer's uuid" do
        let(:uuid) { "f0574ea0-d513-0130-889f-005056a81d80" }
        it {
          subject.uuid_exist?(uuid).should == true
        }
      end

      context "checks an invalid label printer's uuid" do
        let(:uuid) { "not valid uuid" }
        it {
          subject.uuid_exist?(uuid).should == false
        }
      end

    end
  end
end
