# Copyright 2016 Chris Marchesi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vancluever_hello/version'

Gem::Specification.new do |spec|
  spec.name = 'vancluever_hello'
  spec.version = VanclueverHello::VERSION
  spec.authors = ['Chris Marchesi']
  spec.email = %w(chrism@vancluevertech.com)
  spec.description = 'A hello world app for Sinatra, used to demonstrate a Packer/Terraform pattern'
  spec.summary = spec.description
  spec.homepage = 'https://github.com/vancluever/packer-terraform-example'
  spec.license = 'Apache 2.0'

  spec.files = ['lib/vancluever_hello.rb', 'lib/vancluever_hello/version.rb', 'exe/vancluever_hello']
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.bindir = 'exe'
  spec.require_paths = %w(lib)

  spec.required_ruby_version = ['>= 2.1']

  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'thin', '~> 1.6'

  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'test-kitchen', '~> 1.5'
  spec.add_development_dependency 'kitchen-ec2', '~> 0.10'
  spec.add_development_dependency 'ubuntu_ami', '~> 0.4'
  spec.add_development_dependency 'berkshelf', '~> 4.0'
  spec.add_development_dependency 'aws-sdk', '~> 2.2'
end
