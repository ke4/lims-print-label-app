require 'yaml'

module Lims::PrintLabelApp

  class UserInput
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
      selection.each do |url|
        output.puts i.to_s + '. ' + url + '\n'
        i += 1
      end
      output.puts message

      user_input = input.gets.chomp

      # if user input is numeric, then we validate it
      if user_input.match(/^(\d)+$/) && 
        !valid_user_input_from_selection(user_input, selection.size)
        output.puts "\nThe entered number is not correct. Please type it, again"
        user_input_from_selection(selection, message)
      end

      user_input
    end

    # Returns a list of the root_urls from the config file
    # @return [Array]
    def root_urls
      @config['root_urls'].collect do |key, value|
        key + ": " + value
      end
    end

    # Returns the user selected root url
    # @return [String] root url
    def root_url
      input = user_input_from_selection(
        root_urls,
      <<EOD
Please choose from the above list and enter its number.
Alternatively, you can enter another URL, which is not in the list.
EOD
        )

      if input.match(/^(\d)+$/)
        root_url = root_urls[input.to_i]
      else 
        root_url = input
      end

      root_url
    end

    private
    def valid_user_input_from_selection(selection, size)
      valid = true
      if selection.match(/^(\d)+$/) && 
        selection.to_i >= size
        valid = false
      end
      valid
    end
  end
end
