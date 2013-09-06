require 'mymustache/template'
require 'spec_helper'

describe Mustache::Template do
  let(:template_text) { 
    get_file_as_string(File.join('spec', 'test_files', 'tube_rack_template.txt'))
  }
  subject { Mustache::Template.new(template_text) }

  it { subject.tags.should be_a_kind_of(Array) }
end
