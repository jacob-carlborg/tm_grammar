# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tm_grammar/version'

Gem::Specification.new do |spec|
  spec.name          = 'tm_grammar'
  spec.version       = TmGrammar::VERSION
  spec.authors       = ['Jacob Carlborg']
  spec.email         = ['doob@me.com']

  spec.summary       = 'Tool for generating TextMate grammar'
  spec.homepage      = 'https://github.com/jacob-carlborg/tm_grammar'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem '\
      'pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2.4'
  spec.add_dependency 'pattern-match', '~> 1.0.1'

  spec.add_development_dependency 'bundler', '~> 1.10.5'
  spec.add_development_dependency 'pry', '~> 0.10.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.2.0'
  spec.add_development_dependency 'pry-rescue', '~> 1.4.2'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9.2'
  spec.add_development_dependency 'rake', '~> 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'rubocop', '~> 0.34.0'
end
