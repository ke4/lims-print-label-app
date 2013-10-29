require 'lims-print-label-app/util/request_api'
require 'virtus'
require 'aequitas'

module Lims::PrintLabelApp
  module Util
    class LabelPrinterRequest
      include Virtus
      include Aequitas
      include API

      LABEL_PRINTERS_KEY  = 'label_printers'
      LABEL_PRINTER_KEY   = 'label_printer'
      LABELS_ARRAY_KEY    = 'labels'
      TEMPLATE_KEY        = 'template'
      HEADER_TEXT_KEY     = 'header_text'
      FOOTER_TEXT_KEY     = 'footer_text'

      # @param [String] url of the server to send the request
      def initialize(url)
        initialize_api(url)
      end

      # Returns a label printer's uuid of the printer with the given name
      # is exists, otherwise returns nil.
      # @param [String] the name of the label printer
      # @return [String] the uuid of the label printer or nil
      def uuid_by_name(printer_name)
        uuid = nil

        label_printers.each do |label_printer|
          if label_printer["name"] == printer_name
            uuid = label_printer["uuid"]
            break
          end
        end

        uuid
      end

      def uuid_exist?(uuid)
        valid = false

        label_printers.each do |label_printer|
          if label_printer["uuid"] == uuid
            valid = true
            break
          end
        end

        valid
      end

      # Returns the label printers from the root JSON
      def label_printers
        get(url_for(LABEL_PRINTERS_KEY, "first"))[LABEL_PRINTERS_KEY]
      end

      def label_printer(label_printer_uuid)
        get_by_uuid(label_printer_uuid)[LABEL_PRINTER_KEY]
      end

      def header_text(label_printer_uuid)
        label_printer(label_printer_uuid)['header']
      end

      def footer_text(label_printer_uuid)
        label_printer(label_printer_uuid)['footer']
      end

      def print_label(label_printer_uuid, labels)
        parameters = {  LABEL_PRINTER_KEY => {
                        LABELS_ARRAY_KEY => labels[:labels],
                        HEADER_TEXT_KEY => labels[:header],
                        FOOTER_TEXT_KEY => labels[:footer] }
        }
        post(url_by_uuid(label_printer_uuid), parameters)
      end

    end
  end
end
