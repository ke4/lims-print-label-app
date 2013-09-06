require 'yaml'

module Lims::PrintLabelApp
  module Util
    module JsonProcessor
      def self.label_printers(printers_json)
        printers_data = YAML.load(printers_json)["label_printers"]

        printers_data.collect do |printer|
          { :name        => printer["name"], 
            :label_type  => printer["label_type"],
            :uuid        => printer["uuid"]}
        end
      end

      def self.templates(printer_json)
        templates_data = YAML.load(printer_json)["label_printer"]["templates"]

        templates_data.collect do |template|
          { :name         => template["name"],
            :description  => template["description"],
            :content      => template["content"]
          }
        end
      end
    end
  end
end
