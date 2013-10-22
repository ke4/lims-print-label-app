require 'lims-print-label-app/util/color_output'
require 'virtus'
require 'aequitas'
require 'mymustache/template'

module Lims::PrintLabelApp

  class UserInput
    include Util::ColorOutput
    include Virtus
    include Aequitas

    attr_accessor :input, :output

    def initialize
      self.input  = $stdin
      self.output = $stdout

      # loads the options from the config_file
      @config = YAML.load_file(File.join('config','options.yml'))
    end

    # Gets the user selection from a list
    # The user also have the possibility to enter an element,
    # which is not in the list.
    # @param [Array] selection list a user can choose from
    # @param [String] message appears after the selection list
    # @return [String] user_input can be a number (in String) or a String
    def user_input_from_selection(selection, message)
      i = 1
      output.puts
      selection.each do |item|
        output.puts i.to_s + '. ' + item[:to_display]
        i += 1
      end
      puts_message message

      user_input = input.gets.chomp

      # if user input is numeric, then we validate it
      if user_input.match(/^(\d)+$/) && 
        !valid_user_input_from_selection(user_input, selection.size)
        puts_error "\nThe entered number is not correct. Please type it again!"
        output.puts
        user_input = user_input_from_selection(selection, message)
      end

      user_input
    end

    # Returns the user selected root url
    # @return [String] root url
    def root_url
      input = user_input_from_selection(
        root_urls,
      "Please choose from the above list and enter its number.\n" +
      "Alternatively, you can enter another URL, which is not in the list.")

      if input.match(/^(\d)+$/)
        root_url = selected_value(root_urls, input)
      else 
        root_url = input
      end

      root_url
    end

    def label_printer_requests(app_root_url_from_config)
      app_root_url = app_root_url_from_config != nil ? app_root_url_from_config : root_url
      Lims::PrintLabelApp::Util::LabelPrinterRequest.new(app_root_url)
    rescue Errno::ECONNREFUSED
      puts_error "The selected server is not available to service your request."
      retry
    end

    def select_printer_uuid_from_json(label_printers)
      printers_to_display = display_label_printers(label_printers)
      input = user_input_from_selection(
        printers_to_display,
        "Please choose a label printer from the above list and enter its number."
        )

      selected_value(printers_to_display, input)
    end

    def select_template(label_printer)
      templates_to_display = display_templates(label_printer)

      input = user_input_from_selection(
        templates_to_display,
        "Please choose a template from the above list and enter its number."
        )

      { :name => selected_name(templates_to_display, input),
        :text => selected_value(templates_to_display, input) }
    end

    def fill_in_template(template_text, template_values, place)
      template = Mustache::Template.new(template_text)
      puts_message "Please enter the value of the following placeholder in the #{place}."
      template.tags.each do |tag|
        output.print tag + ": "
        user_input = input.gets.chomp
        template_values = add_template_value(template_values, tag, user_input)
      end
#      Mustache.render(template, template_values)
      template_values
    end

    private
    def add_template_value(template_values, tag, value)
      template_values.rmerge!(
        tag.split('.').reverse.inject(value) { |sum, item| { item => sum } }
      )
    end

    def valid_user_input_from_selection(selection, size)
      valid = true
      if selection.to_i > size
        valid = false
      end
      valid
    end

    def selected_value(selection, user_input)
      selection[user_input.to_i - 1][:value]
    end

    def selected_name(selection, user_input)
      selection[user_input.to_i - 1][:key]
    end

    # Returns a list of the root_urls from the config file
    # @return [Array]
    def root_urls
      @config['root_urls'].collect do |key, value|
        {:key => key, :value => value, :to_display => key+ ": " + value }
      end
    end

    def display_label_printers(label_printers)
      label_printers.collect do |label_printer|
        { :key        => label_printer["name"],
          :value      => label_printer["uuid"],
          :to_display => "printer name: #{label_printer['name']} (uuid: #{label_printer['uuid']}) - label type: #{label_printer['label_type']}"
        }
      end
    end

    def display_templates(label_printer)
      label_printer["templates"].collect do |template|
        { :key        => template["name"],
          :value      => template["content"],
          :to_display => "template name: #{template['name']}, description: #{template['description']}"
        }
      end
    end

  end
end
