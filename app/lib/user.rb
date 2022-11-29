module User
  extend self
  class Cache

    def initialize(name, username)
      @name = name
      @username = username
      @id = 2
    end

    def username
      @username
    end
    def name
      @name
    end
    def id
      @id
    end

  end

end
