require 'lims-print-label-app/user_input'

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
        [ "localhost: http://localhost:9292/",
          "uat: http://uat:8000/",
          "production: http://production:7000/"
        ]
      }
      let(:input) { "2" }

      it {
        subject.root_url.should == root_urls[input.to_i]
      }
    end
  end
end
