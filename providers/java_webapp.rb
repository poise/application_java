#
# Cookbook Name:: application_java
# Provider:: java_webapp
#
# Copyright 2012, ZephirWorks
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
#

include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do

  # include_recipe 'java'

  new_resource.strategy :java_remote_file
end

action :before_deploy do

  directory "#{new_resource.path}/releases" do
    owner new_resource.owner
    group new_resource.group
    mode '0755'
    recursive true
  end

  %w{ log pids system }.each do |dir|
    directory "#{new_resource.path}/shared/#{dir}" do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  if new_resource.database_master_role
    dbm = nil
    # If we are the database master
    if node['roles'].include?(new_resource.database_master_role)
      dbm = node
    else
    # Find the database master
      results = search(:node, "role:#{new_resource.database_master_role} AND chef_environment:#{node.chef_environment}", nil, 0, 1)
      rows = results[0]
      if rows.length == 1
        dbm = rows[0]
      end
    end

    # Assuming we have one...
    if dbm
      template "#{new_resource.path}/shared/#{new_resource.application.name}.xml" do
        source new_resource.context_template || "context.xml.erb"
        cookbook new_resource.context_template ? new_resource.cookbook_name : "application_java"
        owner new_resource.owner
        group new_resource.group
        mode "644"
        variables(
          :path => "#{new_resource.path}/current",
          :app => new_resource.application.name,
          :host => (dbm.attribute?('cloud') ? dbm['cloud']['local_ipv4'] : dbm['ipaddress']),
          :database => new_resource.database,
          :war => "#{new_resource.path}/releases/#{new_resource.application.revision}.war"
        )
      end
    else
      Chef::Log.warn("No node with role #{new_resource.database_master_role}, #{new_resource.context_template} not rendered!")
    end
  end

end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end