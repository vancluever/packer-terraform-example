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

SRC_PATH = node['packer_payload']['source_path']
APP_VERSION = node['packer_payload']['app_version']

ruby_runtime '2.1' do
  provider :ruby_build
  action :install
end

ruby_gem "#{SRC_PATH}/vancluever_hello-#{APP_VERSION}.gem" do
  action :install
end

poise_service 'vancluever_hello' do
  command '/opt/ruby_build/builds/2.1/bin/vancluever_hello'
  user node['packer_payload']['app_user']
  directory node['packer_payload']['app_path']
end
