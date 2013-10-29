require 'optparse'
require 'base64'
require 'lims-print-label-app'
require 'lims-print-label-app/user_input'
require 'lims-print-label-app/util/request_api'
require 'lims-print-label-app/util/label_printer_request'
require 'lims-print-label-app/label_templates_filler'
require 'lims-print-label-app/util/color_output'

require 'rubygems'
require 'ruby-debug'

include Lims::PrintLabelApp::Util::ColorOutput

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
# and instantiate the LabelPrinterRequest object,
# which will represent the choosen label printer
label_printer_requests = user_input.label_printer_requests(options[:root_url])

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

label_printer = label_printer_requests.label_printer(label_printer_uuid)
header = Base64.decode64(label_printer_requests.header_text(label_printer_uuid))
footer = Base64.decode64(label_printer_requests.footer_text(label_printer_uuid))

# 3. step
# Choose the template(s) to print the label
# and fill in the selected template(s).
templates_filler = Lims::PrintLabelApp::LabelTemplatesFiller.new(label_printer, user_input)
label_to_print = templates_filler.select_and_fill_templates

# 4. step
# Fill in the header and footer
label_to_print.merge!(templates_filler.fill_header_and_footer(header, footer))

# 5. step
# Print the label
print = label_printer_requests.print_label(label_printer_uuid, label_to_print)

puts "The response from the server:"
pp print

puts_message "\nThe required label has been printed with the given label printer.\n" +
  "Please, collect your label from the printer."
exit
