# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'rack/contrib'

require_relative 'settings'
require_relative 'graphql/schema'
require_relative 'middleware/gandalf'

# Main app
class UserApp < Sinatra::Base
  use Rack::JSONBodyParser
  use Gandalf::RateLimitter

  before do
    Settings.global[:db].create_table? :users do
      primary_key :id
      String :name
      String :email
    end
    @users = Settings.global[:db][:users]
  end

  get '/users' do
    json data: { users: @users.all }
  end

  post '/users' do
    user_id =  @users.insert(params)
    json data: { createUser: @users.first(id: user_id) }
  end

  delete '/users' do
    @users.delete
    json data: { deleteUsers: :ok }
  end

  post '/graphql' do
    result = UserAppSchema.execute(
      params[:query],
      variables: params[:variables]
    )
    json result
  end
end
