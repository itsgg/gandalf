# frozen_string_literal: true

require 'yaml'
require 'prorate'
require 'logger'

module Gandalf
  # You shall not poass
  class RateLimitter
    attr_reader :app, :config, :redis, :logger

    def initialize(app)
      @app = app
      @config = YAML.load_file('./gandalf.yml')
      @redis = Redis.new
      @logger = Logger.new($stdout)
    end

    def call(env)
      request = Rack::Request.new(env)
      parsed_query = GraphQL::Query.new(UserAppSchema, request.params['query'])
      parsed_query.document.nil? ? handle_rest(request) : handle_graphql(request)
      app.call(env)
    rescue Prorate::Throttled => e
      [429, { 'Retry-After' => e.retry_in_seconds.to_s }, []]
    end

    private

    def handle_graphql(request)
      parsed_query = GraphQL::Query.new(UserAppSchema, request.params['query'])
      operation_type = parsed_query.selected_operation.operation_type
      operation_name = parsed_query.selected_operation.name
      tconf = config['graphql'][operation_type][operation_name]
      return if tconf.nil?

      throttle! name: parsed_query.operation_name, limit: tconf['limit'], period: tconf['period'],
                block_for: tconf['block_for'], discriminators: [request.ip, operation_type, operation_name]
    end

    def handle_rest(request)
      tconf = config['http'][request.request_method][request.path]
      return if tconf.nil?

      throttle! name: request.path, limit: tconf['limit'], period: tconf['period'],
                block_for: tconf['block_for'], discriminators: [request.ip, request.path]
    end

    def throttle!(name:, limit:, period:, block_for:, discriminators: [])
      t = Prorate::Throttle.new redis: redis, logger: logger, name: name,
                                limit: limit, period: period, block_for: block_for
      discriminators.each { |discriminator| t << discriminator }
      t.throttle!
    end
  end
end
