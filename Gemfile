# lock that bundler
if (version = Gem::Version.new(Bundler::VERSION)) < Gem::Version.new('2.1.4')
  abort "Bundler version >= 2.1.4 is required. You are running #{version}"
end

source 'https://rubygems.org'
ruby '2.7.4'

# https://github.com/rubygems/rubygems/tree/master/bundler
gem 'bundler', '~> 2.2.29'

# https://github.com/rails/thor
gem 'thor'

# https://github.com/lostisland/faraday
gem 'faraday'

# https://github.com/lostisland/faraday_middleware
gem 'faraday_middleware'

# https://github.com/awesome-print/awesome_print
gem 'awesome_print'
