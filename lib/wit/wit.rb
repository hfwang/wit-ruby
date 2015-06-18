require 'faraday'
require 'faraday_middleware'

module Wit
  DEFAULT_VERSION = '20141022'

  class << self
    attr_accessor :token, :version

    def token
      @token || ENV['WIT_TOKEN']
    end

    def version
      @version || ENV['WIT_VERSION'] || DEFAULT_VERSION
    end
  end

  def self.message(message = '')
    response = connection.get do |req|
      req.headers['Authorization'] = "Bearer #{token}"
      req.headers['Accept'] = "application/vnd.wit.#{version}+json"
      req.url '/message', q: message
    end

    case response.status
    when 200 then return response.body
    when 401 then raise Unauthorized, "incorrect token set for Wit.token set an env for WIT_TOKEN or set Wit::TOKEN manually"
    else raise BadResponse, "response code: #{response.status}"
    end
  end

  def self.connection
    @connection ||= Faraday.new url: 'https://api.wit.ai' do |faraday|
      faraday.use      Faraday::Response::Mashify
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter  Faraday.default_adapter
    end
  end

  class Unauthorized < Exception; end
  class BadResponse < Exception; end
end
