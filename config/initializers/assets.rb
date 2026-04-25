# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Don't cache assets in development
Rails.application.config.assets.cache = false if Rails.env.development?