source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'jekyll', versions['jekyll']
gem 'jekyll-paginate', versions['jekyll-paginate']
gem 'github-pages', versions['github-pages']
gem 'rake'
