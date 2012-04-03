#
# Cookbook Name:: application_java
# Library:: resource_java_remote_file
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

require 'chef/resource/remote_file'

class Chef
  class Resource
    class JavaRemoteFile < Chef::Resource::RemoteFile

      alias :user :owner
      alias :revision :checksum

      def initialize(name, run_context=nil)
        super
        @resource_name = :java_remote_file
        @provider = Chef::Provider::JavaRemoteFile
      end

      def provider
        Chef::Provider::JavaRemoteFile
      end

      def deploy_to(dir = nil)
        if dir
          @deploy_to = dir
          path dir
        else
          @deploy_to
        end
      end

      def repository(url)
        source url
      end

      def release_path
        @release_path ||= @deploy_to + "/releases/#{checksum}.war"
      end

      def current_path
        @current_path ||= @deploy_to + "/current"
      end

      def method_missing(name, *args, &block)
        Chef::Log.info "java_remote_file missing(#{name}, #{args.inspect}), ignoring it"
      end

    end
  end
end
