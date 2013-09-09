require 'optparse'
require 'lims-print-label-app'
require 'lims-print-label-app/user_input'
require 'lims-print-label-app/util/request_api'
require 'lims-print-label-app/util/label_printer_request'

require 'rubygems'
require 'ruby-debug'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: print_label.rb [options]"
  opts.on("-u", "--root_url U")     { |u| options[:root_url]      = u }
  opts.on("-p", "--printer_name P") { |p| options[:printer_name]  = p }
  opts.on("-i", "--printer_uuid I") { |i| options[:printer_uuid]  = i }
  opts.on("-e", "--ean13 E")        { |e| options[:ean13]         = e }
  opts.on("-s", "--sanger_code S")  { |s| options[:sanger]        = s }
  opts.on("-r", "--role R")         { |r| options[:role]          = r }
  opts.on("-l", "--labware L")      { |l| options[:labware]       = l }
end.parse!

user_input = Lims::PrintLabelApp::UserInput.new

# 1. step
# Gets the application's root URL from the user
# if it is not given as a parameter
app_root_url = options[:root_url] != nil ? options[:root_url] : user_input.root_url

label_printer_requests = Lims::PrintLabelApp::Util::LabelPrinterRequest.new(app_root_url)

# 2. step
# Choose the label printer the user wants to use.
# If it is given as a parameter either as a printer name or
# as a printer uuid, then validate it and get the printer uuid
# in case of the printer name has been given.
valid_printer_uuid = false
if options[:printer_name]
  label_printer_uuid = LabelPrinterUtil::uuid_by_name(options[:printer_name])
  valid_printer_uuid = true
end
if !valid_printer_uuid &&
  options[:printer_uuid] &&
  LabelPrinterUtil::uuid_exist?(options[:printer_uuid])
  valid_printer_uuid = true
  label_printer_uuid = options[:printer_uuid]
end

unless valid_printer_uuid
  label_printers = label_printer_requests.label_printers
  label_printer_uuid = user_input.select_printer_uuid_from_json(label_printers)
  valid_printer_uuid = true
end


