$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'erb'
require 'display'
require 'web_display'

run WebDisplay::App

