# frozen_string_literal: true

require 'graphql'
require_relative 'base_object'

module Types
  class Ok < Types::BaseObject
    description 'Success response'

    field :data, String, null: false
  end
end
