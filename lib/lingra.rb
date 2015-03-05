require 'lingra/version'
require 'net/http'
require 'uri'
require 'json'

module Lingra

  API_ROOT = 'http://lingr.com/api/'

  class Client

    def initialize username, password, app_key, debug = false
      @debug = debug
      @username = username
      @password = password
      @app_key = app_key
      @session = Lingra::Session.new username, password, app_key
    end

    def connect
      @session.start unless @session || @session.dead?
      @session.alive?
    end

    def disconnect
      @session.stop if @session.alive?
      @session.dead?
    end

    # Session

    def create_session
    end

    def verify_session
    end

    def destroy_session
    end

    # User

    def list_user_rooms
    end

    # Room

    def room
    end

    def list_archives
    end

    def subscribe_room
    end

    # Favorite

    # Event

    private
    def get path, port = 8080, params = nil
      url = URI.parse API_ROOT + path
      req = Net::HTTP::Get.new url.path
      res = Net::HTTP.start(url.host, port) {|http|
        http.request req
      }
      JSON.parse res.body
    end

    def post path, port = 80, params = nil
      url = URI.parse API_ROOT + path
      req = Net::HTTP::Post.new url.path
      req.set_form_data params, ';' if params
      res = Net::HTTP.start(url.host, port) {|http|
        http.request req
      }
      JSON.parse res.body
    end

  end

  class Session

    def initialize client
      @client = client
    end

    def start
    end

    def stop
    end

    def alive?
    end

    def dead?
    end

  end

  class Room

    attr_reader :id, :name, :log, :members

    def initialize id, name, public
      @id = id
      @name = name
      @public = public
      @log = []
      @members = {}
    end

    def public?
      @public
    end

    def private?
      !public?
    end

    def add_member member
      @members[member.username] = member
    end

    def remove_member member
      @members.delete member.username
    end



  end

  class Member

    attr_reader :username, :name, :icon_url
    attr_writer :owner, :online

    def initialize username, name, icon_url, owner, online
    end

    def owner?
      @owner
    end

    def online?
      @online
    end

    def offline?
      !online?
    end

  end

  class Message

    def initialize id, type, nickname, speaker_id, public_session_id, text, timestamp, mine
      @id = id

    end

  end

end
