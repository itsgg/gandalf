# frozen_string_literal: true

require 'graphql'
require_relative 'mutations/create_user'
require_relative 'mutations/delete_users'

# Configures mutation of the app
class MutationType < GraphQL::Schema::Object
  description 'Root Mutation'

  field :createUser, mutation: Mutations::CreateUser
  field :deleteUsers, mutation: Mutations::DeleteUsers
end
