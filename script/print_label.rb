require 'optparse'
require 'lims-print-label-app'
require 'lims-print-label-app/user_input'

require 'rubygems'
require 'ruby-debug'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: print_label.rb [options]"
  opts.on("-e", "--ean13 E")        { |e| options[:ean13]         = e }
  opts.on("-s", "--sanger_code S")  { |s| options[:sanger]        = s }
  opts.on("-r", "--role R")         { |r| options[:role]          = r }
  opts.on("-p", "--printer_name P") { |p| options[:printer_name]  = p }
  opts.on("-u", "--root_url U")     { |u| options[:root_url]      = u }
  opts.on("-i", "--printer_uuid I") { |i| options[:printer_uuid]  = i }
  opts.on("-l", "--labware L")      { |l| options[:labware]       = l }
end.parse!

user_input = Lims::PrintLabelApp::UserInput.new

# 1. step
# Gets the application's root URL from the user
# if it is not given as a parameter
app_root_url = options[:root_url] != nil ? options[:root_url] : user_input.root_url
