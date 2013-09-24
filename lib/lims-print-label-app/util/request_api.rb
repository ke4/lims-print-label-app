require 'rest_client'
require 'json'

module Lims::PrintLabelApp
  module Util
    # A module for handling the GET and POST request to the server
    module API

      HEADERS = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}

      module Request
        # Sends a GET request to the server and parses the response JSON
        # @return [Hash] the response JSON converted to a Hash
        def get(url)
          response = RestClient.get(url, HEADERS)
          JSON.parse(response)
        end

        # Sends a POST request to the server and parses the response JSON
        # @return [Hash] the response JSON converted to a Hash
        def post(url, parameters)
          response = RestClient.post(url, parameters.to_json, HEADERS)
          JSON.parse(response)
        end
      end

      include Request

      def self.included(klass)
        klass.class_eval do
          attribute :root, String, :required => true, :writer => :private, :reader => :private
        end
      end

      # @param [String] root_url the root url of the server
      def initialize_api(root_url)
        @root_url = root_url
        @root = get(@root_url)
      end

      # Gets the action url of the given model
      # @return [String] the action url of the given model
      def url_for(model, action)
        @root[model.to_s]["actions"][action.to_s]
      end

      # Gets the resource's URL by its uuid
      # @return [String] the resource's URL by its uuid
      def url_by_uuid(uuid)
        File.join(@root_url,uuid)
      end

      # Gets a resource JSON by its uuid
      # @return [String] the resource JSON by its uuid
      def get_by_uuid(uuid)
        get(File.join(@root_url,uuid))
      end
    end
  end
end
