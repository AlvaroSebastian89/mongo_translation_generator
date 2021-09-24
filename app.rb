require 'mongoid'
require 'active_record'
require 'yaml'
require "i18n"

$environment = ENV['TRANSLATION_ENV'] || 'development'
$settings = YAML.load_file(File.expand_path('../config/settings.yml', __FILE__))[$environment]

# Credentials
$access_token = '5b070905faaf4f12ded38f7c8f58a6ed40498d40'
$mk_id = 1

# MongoDB
Mongoid.load!("./config/mongoid.yml", :development)

# Helpers
require File.expand_path('../helpers/api.rb', __FILE__)

# Models
require File.expand_path('../models/int_shipping_translator.rb', __FILE__)

# Controllers
require File.expand_path('../controllers/translation_controller.rb', __FILE__)
require File.expand_path('../controllers/zone_controller.rb', __FILE__)
require File.expand_path('../controllers/chilexpress_controller.rb', __FILE__)

TranslationController.process