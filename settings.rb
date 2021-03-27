# frozen_string_literal: true

require 'sequel'

# Maintaing global level settings
module Settings
  def self.global
    @global ||= {}
  end
end

Settings.global[:db] = Sequel.connect('sqlite://db.sqlite')
