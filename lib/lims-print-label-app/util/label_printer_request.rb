require 'lims-print-label-app/util/request_api'
require 'virtus'
require 'aequitas'

module Lims::PrintLabelApp
  module Util
    class LabelPrinterRequest
      include Virtus
      include Aequitas
      include API

      LABEL_PRINTERS_KEY = 'label_printers'

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
          uuid = label_printer["uuid"] if label_printer["name"] == printer_name
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
    end
  end
end
