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
end

action :before_deploy do

  create_hierarchy

  create_context_file

end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end

protected

def create_hierarchy
  %w{ log pids system }.each do |dir|
    directory "#{new_resource.path}/shared/#{dir}" do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
      recursive true
    end
  end
end

def create_context_file
  host = new_resource.find_database_server(new_resource.database_master_role)

  template "#{new_resource.path}/shared/#{new_resource.application.name}.xml" do
    source new_resource.context_template || "context.xml.erb"
    cookbook new_resource.context_template ? new_resource.cookbook_name.to_s : "application_java"
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables(
      :path => "#{new_resource.path}/current",
      :app => new_resource.application.name,
      :host => host,
      :database => new_resource.database,
      :war => "#{new_resource.path}/current/#{new_resource.war || ::File.basename(new_resource.application.repository)}"
    )
  end
end
