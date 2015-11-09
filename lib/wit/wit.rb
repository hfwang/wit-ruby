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

  def self.message(message='', opts=nil)
    response = connection.get do |req|
      opts ||= {}

      params = { :q => message }
      params[:msg_id] = opts[:message_id] if opts.has_key?(:message_id)
      params[:thread_id] = opts[:thread_id] if opts.has_key?(:thread_id)
      params[:n] = opts[:num_results] if opts.has_key?(:num_results)
      params[:context] = JSON.generate(opts[:context]) if opts.has_key?(:context)

      req.url('/message', params)
    end

    return self.handle_response(response)
  end

  def self.list_intents
    response = connection.get do |req|
      req.url "/intents"
    end

    return self.handle_response(response)
  end

  def self.get_intent(intent_id_or_name)
    response = connection.get do |req|
      req.url "/intents/#{intent_id_or_name}"
    end

    return self.handle_response(response)
  end

  def self.add_expression(intent_id_or_name, expression)
    response = connection.post do |req|
      req.url "/intents/#{intent_id_or_name}/expressions"
      req.body = [{ body: expression }].to_json
    end

    return self.handle_response(response)
  end

  def self.handle_response(response)
    case response.status
    when 200 then return response.body
    when 401 then raise Unauthorized, "incorrect token set for Wit.token set an env for WIT_TOKEN or set Wit::TOKEN manually"
    else raise BadResponse, "response code: #{response.status}"
    end
  end

  def self.connection
    @connection ||= Faraday.new('https://api.wit.ai',
                                headers: {
                                  'Authorization' => "Bearer #{self.token}",
                                  'Content-Type' => "application/json",
                                  'Accept' => "application/vnd.wit.#{self.version}+json"
                                }) do |faraday|
      faraday.use      Faraday::Response::Mashify
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter  Faraday.default_adapter
    end
  end

  class Unauthorized < Exception; end
  class BadResponse < Exception; end
end
