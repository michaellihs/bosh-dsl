module Helpers

  module Credentials

    def self.get_or_create(key)
      "SECRET #{key}"
    end

  end

  module Bosh

    def self.director_uuid(target)
      # TODO implement me
      '1234-1234-1234-1234'
    end

  end

end