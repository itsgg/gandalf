# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'

module Mutations
  # Create a new user
  class CreateUser < Mutations::BaseMutation
    description 'Creates a user'

    argument :name, String, required: false
    argument :email, String, required: false

    type Types::User
    null false

    def resolve(name:, email:)
      users = Settings.global[:db][:users]

      user_id = users.insert(name: name, email: email)

      GraphQl::ExecutionError.new('Create failed!') if user_id.nil?

      users.first(id: user_id)
    end
  end
end
