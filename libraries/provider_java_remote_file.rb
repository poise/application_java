#
# Cookbook Name:: application_java
# Library:: provider_java_remote_file
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

require 'chef/provider/remote_file'

class Chef
  class Provider
    class JavaRemoteFile < Chef::Provider::RemoteFile

      def load_current_resource
        @new_resource.path @new_resource.release_path
        super
      end

      def action_deploy
        action_create
      end

      def action_force_deploy
        action_create
      end

    end
  end
end
