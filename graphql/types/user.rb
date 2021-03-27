# frozen_string_literal: true

require 'graphql'
require_relative 'base_object'

module Types
  class User < Types::BaseObject
    description 'User Type'

    field :id, Integer, null: false
    field :name, String, null: false
    field :email, String, null: true
  end
end
