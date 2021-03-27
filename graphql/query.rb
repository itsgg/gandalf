# frozen_string_literal: true

require 'graphql'
require_relative 'types/user'

# Configures queries of the app
class QueryType < GraphQL::Schema::Object
  description 'The query root of this schema'

  field :users, [Types::User], null: false do
    description 'Get the list of all users'
  end

  def users
    Settings.global[:db][:users].all
  end
end
