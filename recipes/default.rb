#
# Cookbook:: office2016
# Recipe:: default
#
# Copyright:: 2018, Nghiem Ba Hieu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

chef_cache_path = Chef::Config[:file_cache_path]
download_filename = 'officedeploymenttool_11107-33602.exe'
deployment_download_path = ::File.join(chef_cache_path, download_filename)
deployment_exe_path = ::File.join(chef_cache_path, 'setup.exe')
configuration_template = ::File.join(chef_cache_path, 'configure.xml')

remote_file deployment_download_path do
  source 'https://storage.googleapis.com/chef_files/officedeploymenttool_11107-33602.exe'
  checksum '1A4EA8230699A8AB98BD9D7742C1EBE47BE679EDAFFC2CE860244FD0D4B8A686'
  action :create_if_missing
end

execute 'get deployment tool' do
  command "#{deployment_download_path} /quiet /extract:#{chef_cache_path}"
  not_if { ::File.exist?(deployment_exe_path) }
end

template configuration_template do
  source 'configuration.xml.erb'
  variables(
    edition: node['office2016']['edition'],
    channel: node['office2016']['channel']
  )
end

language_id = node['office2016']['language'] || 'en-us'

windows_package "Microsoft Office 365 ProPlus - #{language_id}" do
  source deployment_exe_path
  action :install
  installer_type :custom
  options "/configure #{configuration_template}"
  timeout node['office2016']['timeout'] || 1500
end

include_recipe 'office2016::configure'
