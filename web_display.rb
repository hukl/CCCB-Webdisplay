$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'erb'
require 'display'

module WebDisplay

  class App < Sinatra::Base
    set :run
    set :views, File.dirname(__FILE__) + '/views'
    set :public, File.dirname(__FILE__) + '/public'

    get "/" do
      erb :webform
    end

    post "/update" do
      text = params["text"]

      puts "text: #{text.inspect}"

      Display.connect("172.23.42.120", 2342) do
        update( text.split(/\n/).map{|x| x.ljust(56)}.join )
      end

      redirect "/webform"

    end

    post "/intensity" do

      value = params["intensity"]
      puts ">>>>>>>>>>>>>> #{value}"

      Display.connect("172.23.42.120", 2342) do
        update( value, { :command => 7, } )
      end

    end
  end
end
