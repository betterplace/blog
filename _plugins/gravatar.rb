require 'digest/md5'

module Jekyll
  module GravatarFilter

    # Add our new liquid filter.
    def gravatar(email)
      "https://secure.gravatar.com/avatar/#{hash(email)}.jpg?d=mm&s=80"
    end

    private

    def hash(email)
      Digest::MD5.hexdigest(email.to_s.downcase.strip)
    end
  end
end

Liquid::Template.register_filter(Jekyll::GravatarFilter)
