require_relative "lib/jvc/projector/version"

Gem::Specification.new do |s|
  s.name = 'jvc_projector'
  s.version = JVC::Projector::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Cody Cutrer"]
  s.email = "cody@cutrer.com'"
  s.homepage = "https://github.com/ccutrer/jvc_projector_ruby"
  s.summary = "Library for communication with JVC Projectors"
  s.license = "MIT"

  s.executables = ['jvc_mqtt_bridge']
  s.files = Dir["{bin,lib}/**/*"]

  s.add_dependency 'ccutrer-serialport', "~> 1.1"
  s.add_dependency 'homie-mqtt', "~> 1.1"
  s.add_dependency 'net-telnet-rfc2217', "~> 0.0.3"
  s.add_dependency 'thor', '~> 1.1'

  s.add_development_dependency 'byebug', "~> 9.0"
  s.add_development_dependency 'rake', "~> 13.0"
end
