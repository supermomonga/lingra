require "lingra/version"

module Lingra


  class Client

    def initialize username, password, app_key
      @debug = false
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

    def room_ids

    end

    private
    def request method, path, params = {}
    end

    def get path, params = {}
      request :get, path, params
    end

    def post path, params = {}
      request :post, path, params
    end

  end

  class Session

    def initialize username, password, app_key
      @username = username
      @password = password
      @app_key = app_key
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
