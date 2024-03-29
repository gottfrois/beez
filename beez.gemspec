require_relative 'lib/beez/version'

Gem::Specification.new do |spec|
  spec.name          = 'beez'
  spec.version       = Beez::VERSION
  spec.authors       = ['Pierre-Louis Gottfrois']
  spec.email         = ['pierrelouis.gottfrois@gmail.com']

  spec.summary       = 'Simple, efficient ruby workers for Zeebe business processes.'
  spec.description   = 'Simple, efficient ruby workers for Zeebe business processes.'
  spec.homepage      = 'https://github.com/gottfrois/beez'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gottfrois/beez'
  spec.metadata['changelog_uri'] = 'https://github.com/gottfrois/beez/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_dependency 'zeebe-client', '~> 0.7'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'
end
