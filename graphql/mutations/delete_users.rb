# frozen_string_literal: true

require 'graphql'
require_relative 'base_mutation'
require_relative '../types/ok'

module Mutations
  # Create a new user
  class DeleteUsers < Mutations::BaseMutation
    description 'Delete all users'

    type Types::Ok
    null false

    def resolve
      Settings.global[:db][:users].delete

      { data: :ok }
    end
  end
end
