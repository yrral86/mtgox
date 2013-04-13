require 'faraday'
require 'faraday/request/url_encoded'
require 'faraday/response/raise_error'
require 'faraday/response/raise_mtgox_error'
require 'mtgox/response/parse_json'
require 'mtgox/version'

module MtGox
  module Connection
    private

    def connection
      options = default_connection_options

      Faraday.new(options) do |connection|
        connection.request :url_encoded
        connection.use Faraday::Response::RaiseError
        connection.use MtGox::Response::ParseJson
        connection.use Faraday::Response::RaiseMtGoxError
        connection.adapter(Faraday.default_adapter)
      end
    end

    def data_connection
      options = default_connection_options
      options[:url] = 'https://data.mtgox.com'

      Faraday.new(options) do |connection|
        connection.request :url_encoded
        connection.use Faraday::Response::RaiseError
        connection.use MtGox::Response::ParseJson
        connection.use Faraday::Response::RaiseMtGoxError
        connection.adapter(Faraday.default_adapter)
      end
    end

    private
    def default_connection_options
      {
        headers:  {
          accept: 'application/json',
          user_agent: "mtgox gem #{MtGox::Version}",
        },
        url: 'https://mtgox.com',
        ssl: {verify: false}
      }
    end
  end
end
