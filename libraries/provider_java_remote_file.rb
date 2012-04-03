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

      def action_create
        super
        symlink
      end

      def symlink
        purge_tempfiles_from_current_release
        link_tempfiles_to_current_release
        link_current_release_to_production
        Chef::Log.info "#{@new_resource} updated symlinks"
      end

      def purge_tempfiles_from_current_release
      end

      def link_tempfiles_to_current_release
      end

      def link_current_release_to_production
        FileUtils.rm_f(@new_resource.current_path)
        begin
          FileUtils.ln_sf(@new_resource.release_path, @new_resource.current_path)
        rescue => e
          raise Chef::Exceptions::FileNotFound.new("Cannot symlink current release to production: #{e.message}")
        end
        Chef::Log.info "#{@new_resource} linked release #{@new_resource.release_path} into production at #{@new_resource.current_path}"
        enforce_ownership
      end

      def enforce_ownership
        FileUtils.chown_R(@new_resource.user, @new_resource.group, @new_resource.deploy_to)
        Chef::Log.info("#{@new_resource} set user to #{@new_resource.user}") if @new_resource.user
        Chef::Log.info("#{@new_resource} set group to #{@new_resource.group}") if @new_resource.group
      end

    end
  end
end
