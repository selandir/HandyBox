# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.

# for mount_uploader working correctly
require 'carrierwave/orm/activerecord'

Rails.application.initialize!
