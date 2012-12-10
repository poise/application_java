#
# Cookbook Name:: application_java
# Library:: resource_java_local_file
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

require 'chef/resource/file'

class Chef
  class Resource
    class JavaLocalFile < Chef::Resource::File

      alias :user :owner
      alias :repository :content

      def initialize(name, run_context=nil)
        super
        @resource_name = :java_local_file
        @provider = Chef::Provider::File::JavaLocalFile
        @deploy_to = nil
        @allowed_actions.push(:deploy,:force_deploy)
      end

      def provider
        Chef::Provider::File::JavaLocalFile
      end

      def deploy_to(args=nil)
        set_or_return(
          :deploy_to,
          args,
          :kind_of => String
        )
      end

      def revision(arg=nil)
        set_or_return(
          :checksum,
          arg,
          :kind_of => String
        )
      end

      def release_path
        @release_path ||= @deploy_to + "/releases/#{revision}.war"
      end

      def method_missing(name, *args, &block)
        Chef::Log.info "java_local_file missing(#{name}, #{args.inspect}), ignoring it"
      end

    end
  end
end
