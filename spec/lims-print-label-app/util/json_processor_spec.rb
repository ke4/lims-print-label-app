require 'lims-print-label-app/util/json_processor'
require 'spec_helper'

module Lims::PrintLabelApp
  module Util
    describe JsonProcessor do
      context "can list the name and type of the registered label printers" do
        let(:json) {
          get_file_as_string(File.join('spec', 'test_files','label_printers.json'))
        }
        it { JsonProcessor.label_printers(json).should respond_to(:each) }
        it { JsonProcessor.label_printers(json).should respond_to(:size) }
        it { JsonProcessor.label_printers(json).should be_a_kind_of(Array) }
        it do
          JsonProcessor.label_printers(json).each do |printer|
            printer.keys.should include(:name, :label_type, :uuid)
            printer[:name].should_not be_nil
            printer[:label_type].should_not be_nil
            printer[:uuid].should_not be_nil
          end
        end
      end

      context "can list the name and type of the registered label printers" do
        let(:json) {
          get_file_as_string(File.join('spec', 'test_files','label_printer.json'))
        }
        it { JsonProcessor.templates(json).should respond_to(:each) }
        it { JsonProcessor.templates(json).should respond_to(:size) }
        it { JsonProcessor.templates(json).should be_a_kind_of(Array) }
        it do
          JsonProcessor.templates(json).each do |template|
            template.keys.should include(:name, :description, :content)
            template[:name].should_not be_nil
            template[:description].should_not be_nil
            template[:content].should_not be_nil
          end
        end
      end
    end
  end
end
