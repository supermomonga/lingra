require 'lingra/version'
require 'net/http'
require 'uri'
require 'json'

module Lingra

  API_ROOT = 'http://lingr.com/api/'

  class Client

    def initialize username, password, app_key, rooms = [] debug = false
      @debug = debug
      @username = username
      @password = password
      @user_defined_rooms = rooms
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

    # User

    def list_user_rooms
      json = post 'user/get_rooms', 80, {
                    session: @session.id
                  }
      if json['statu'] == 'ok'
        return json['rooms'].concat(@user_defined_rooms).uniq
      end
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
      json = JSON.parse res.body
      if @client.valid_status? json
        return json
      else
        raise FubenException
      end
    end

    def post path, port = 80, params = nil
      url = URI.parse API_ROOT + path
      req = Net::HTTP::Post.new url.path
      req.set_form_data params, ';' if params
      res = Net::HTTP.start(url.host, port) {|http|
        http.request req
      }
      json = JSON.parse res.body
      return json
    end

    def valid_status? json
      json['status'] == 'ok'
    end

  end

  class Session

    def initialize client
      @client = client
      @id = nil
    end

    def start
      json = @client.post 'session/create', 80, {
                            user: @client.username,
                            password: @client.password,
                            app_key: @client.app_key
                          }
      if json['status'] == 'ok'
        @id = json['session']
      else
        # TODO
      end
    end

    def stop
      return unless @id
      json = @client.post 'session/destroy', 80, {
                            session: @id,
                          }
    end

    def alive?
      return unless @id
      json = @client.post 'session/verify', 80, {
                            session: @id,
                          }
      return case json['status'].to_sym
      when :ok
        true
      when :error
        false
      end
    end

    def dead?
      !alive?
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
