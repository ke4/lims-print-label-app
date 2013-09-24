require 'lims-print-label-app/user_input'
require 'spec_helper'

module Lims::PrintLabelApp
  describe UserInput do
    before do
      subject { UserInput.new }
    end

    context "root_url method returns the app's root URL as a string" do
      before do
        subject.stub(:user_input_from_selection)  { input }
        subject.stub(:root_urls)                  { root_urls }
      end

      let(:root_urls) {
        [ {:key => "localhost",   :value => "http://localhost:9292/",   :to_display => "localhost: http://localhost:9292/"},
          {:key => "uat",         :value => "http://uat:8000/",    :to_display => "uat: http://uat:8000/"},
          {:key => "production",  :value => "http://production:7000/",  :to_display => "production: http://production:7000/"}
        ]
      }
      let(:input) { "2" }

      it {
        subject.root_url.should == root_urls[input.to_i-1][:value]
      }
    end

    context "select_printer_uuid_by_json should return a uuid" do
      before do
        subject.stub(:user_input_from_selection)  { input }
        subject.stub(:uuids)                      { uuids }
      end

      let(:uuids) {
        [ "f0574ea0-d513-0130-889f-005056a81d80",
          "f439b8f0-d513-0130-88a0-005056a81d80",
          "f6166830-d513-0130-88a1-005056a81d80"
        ]
      }
      let(:input) { "1" }
      let(:label_printers) {
        YAML.load(get_file_as_string(File.join('spec', 'test_files','label_printers.json')))["label_printers"]
      }

      it {
        uuid = subject.select_printer_uuid_from_json(label_printers)
        uuid.should be_a_kind_of(String)
        uuid.should match(/^([0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12})?/)
      }
    end

    context "select_template should return a printable template" do
      let(:label_printer_uuid) { "f6166830-d513-0130-88a1-005056a81d80" }

      it {
        template = subject.select_template(label_printer_uuid)
        template.should be_a_kind_of(String)
        template.should match(/PC(\d){3}/)
        template.should match(/RC(\d){3}/)
      }
    end
  end
end
