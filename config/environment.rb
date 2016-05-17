# Set up gems listed in the Gemfile.
# See: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'dotenv'
Dotenv.load
require 'rubygems'

require 'json'


require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?

require 'erb'

require 'faker'

require 'bcrypt'

require 'hyperclient'

require 'httparty'


# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

configure do
  # By default, Sinatra assumes that the root is the file that calls the configure block.
  # Since this is not the case for us, we set it manually.
  set :root, APP_ROOT.to_path
  # See: http://www.sinatrarb.com/faq.html#sessions
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'

  # Set the views to
  set :views, File.join(Sinatra::Application.root, "app", "views")
end

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')

# --------------------------------------
# API STUFF???
# --------------------------------------

client_id = '1881740623d5e60b5ee6'
client_secret = '6eaad746de6ae96129b5854d19868202'

api = Hyperclient.new('https://api.artsy.net/api') do |api|
  api.headers['Accept'] = 'application/vnd.artsy-v2+json'
  api.headers['Content-Type'] = 'application/json'
  api.connection(default: false) do |conn|
    conn.use FaradayMiddleware::FollowRedirects
    conn.use Faraday::Response::RaiseError
    conn.request :json
    conn.response :json, content_type: /\bjson$/
    conn.adapter :net_http
  end
end

xapp_token = api.tokens.xapp_token._post(client_id: client_id, client_secret: client_secret).token
