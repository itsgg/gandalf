# frozen_string_literal: true

require 'graphql'
require_relative '../settings'
require_relative 'query'
require_relative 'mutation'

class UserAppSchema < GraphQL::Schema
  query QueryType
  mutation MutationType
end
