require 'lims-print-label-app/user_input'
require 'spec_helper'
require 'base64'

module Lims::PrintLabelApp
  describe UserInput do

    def get_label_printer_json
      YAML.load(get_file_as_string(File.join('spec', 'test_files','label_printer.json')))
    end

    before do
      UserInput.any_instance.stub(:user_input_from_selection) { input }
      UserInput.any_instance.stub(:root_urls) { root_urls }
    end

    let(:root_urls) {
      [ {:key => "localhost",   :value => "http://localhost:9292/",   :to_display => "localhost: http://localhost:9292/"},
        {:key => "uat",         :value => "http://uat:8000/",    :to_display => "uat: http://uat:8000/"},
        {:key => "production",  :value => "http://production:7000/",  :to_display => "production: http://production:7000/"}
      ]
    }
    let(:input) { "2" }

    context "root_url method returns the app's root URL as a string" do
      it {
        subject.root_url.should == root_urls[input.to_i-1][:value]
      }
    end

    context "select_printer_uuid_by_json should return a uuid" do
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
      it {
        label_printer = get_label_printer_json["label_printer"]
        template = subject.select_template(label_printer)
        template.should be_a_kind_of(Hash)
        Base64.decode64(template[:text]).should match(/PC(\d){3}/)
        Base64.decode64(template[:text]).should match(/RC(\d){3}/)
      }
    end
  end
end
