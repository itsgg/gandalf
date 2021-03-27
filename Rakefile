# frozen_string_literal: true

require 'faker'

PORT = 9393

namespace 'http' do
  desc 'Get all users'
  task :get do
    sh "http get :#{PORT}/users"
  end

  desc 'Create a random user'
  task :post do
    sh "http post :#{PORT}/users name='#{Faker::Name.name}' email='#{Faker::Internet.email}'"
  end

  desc 'Delete all users'
  task :delete do
    sh "http delete :#{PORT}/users"
  end
end

namespace 'graphql' do
  desc 'Get all users'
  task :get do
    sh "http post :#{PORT}/graphql query='query users { users { id, name, email } }'"
  end

  desc 'Create a random user'
  task :post do
    sh "http post :#{PORT}/graphql query='mutation CreateUser(\$name: String!, \$email: String!) { user: createUser(name: \$name, email: \$email) { id, name, email } }' variables:='{ \"name\": \"#{Faker::Name.name}\", \"email\": \"#{Faker::Internet.email}\" }'"
  end

  desc 'Delete all users'
  task :delete do
    sh "http post :#{PORT}/graphql query='mutation DeleteUsers { deleteUsers { data } }'"
  end
end
