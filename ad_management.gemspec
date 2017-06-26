# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ad_management/version'

Gem::Specification.new do |spec|
  spec.name          = 'ad_management'
  spec.version       = AdManagement::VERSION
  spec.authors       = ['Vincent Balbarin', 'E. Camden Fisher']
  spec.email         = ['vincent.balbarin@yale.edu', 'camden.fisher@yale.edu']

  spec.summary       = %q{Active Directory Management}
  spec.description   = %q{This gem is light wrapper for `net-ldap` Ruby. It allows for the management of MS ActiveDirectory}
  spec.homepage      = 'https://git.yale.edu/spinup/yaleits_ad_management'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib', 'lib/ad_management', 'lib/ad_management/objects']

  spec.add_dependency 'awesome_print', '~> 0'
  spec.add_dependency 'cri', '~> 2.7'
  spec.add_dependency 'net-ldap', '~> 0.16.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 11'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
  spec.add_development_dependency 'yard', '~> 0'

  spec.post_install_message = 'Thanks for installing the AD management client!'
end
