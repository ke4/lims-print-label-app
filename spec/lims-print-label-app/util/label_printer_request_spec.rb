require 'lims-print-label-app/util/label_printer_request'
require 'spec_helper'

module Lims::PrintLabelApp
  module Util
    describe LabelPrinterRequest do
#      before do
#        subject { LabelPrinterRequest.new(dummy_url) }
#        subject.stub(:get) {
#          YAML.load(get_file_as_string(File.join('spec', 'test_files','label_printers.json')))
#        }
#        subject.stub(:url_for) {
#          dummy_url
#        }
#      end

      let(:dummy_url) { "http://localhost:9292/"}
      subject { LabelPrinterRequest.new(dummy_url) }
      let(:printer_name) { "d304bc" }

      context "gets a uuid by name" do
        it {
          subject.stub(:get) {
            YAML.load(get_file_as_string(File.join('spec', 'test_files','label_printers.json')))
          }
          subject.stub(:url_for) {
            dummy_url
          }

          uuid = subject.uuid_by_name(printer_name)
          uuid.should be_a_kind_of(String)
          uuid.should match(/^([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})?/)
        }
      end

      context "checks a valid label printer's uuid" do
        let(:uuid) { "b6cdff00-d0ec-0130-2df7-406c8f37cea7" }
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
