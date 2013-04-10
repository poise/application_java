Description
===========

This cookbook is designed to be able to describe and deploy Java web applications. Currently supported:

* Java
* Tomcat

Note that this cookbook provides the Java-specific bindings for the `application` cookbook; you will find general documentation in that cookbook.

Other application stacks may be supported at a later date.

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

The following Opscode cookbooks are dependencies:

* application
* java
* tomcat

Resources/Providers
==========

The LWRPs provided by this cookbook are not meant to be used by themselves; make sure you are familiar with the `application` cookbook before proceeding.

java\_webapp
-----------

The `java\_webapp` sub-resource LWRP deals with deploying Java webapps delivered as WAR files which will either be retrieved from a remote URL or fetched by some other method and referenced locally.

NOTICE: the `application` cookbook was designed around frameworks running on interpreted languages that are deployed in source code, checked out of an SCM using the `deploy_revision` resource. While this cookbook tries to map those concepts to a binary distribution mechanism, it may not map exactly.

# Attribute Parameters

* database\_master\_role: if a role name is provided, a Chef search will be run to find a node with than role in the same environment as the current role. If a node is found, its IP address will be used when rendering the context file, but see the "Database block parameters" section below
* context\_template: the name of template that will be rendered to create the context file; if specified it will be looked up in the application cookbook. Defaults to "context.xml.erb" from this cookbook
* database: a block containing additional parameters for configuring the database connection (see below)
* war: if provided, will override the default of the basename of the repository

# Database block parameters

The database block can accept any method, with the following being expected by the stock context.xml.erb:

* driver: a fully-qualified class name of the JDBC driver
* host: hostname or IP address of the database server; if set it will take precedence over the address returned from the search for database\_master\_role
* port: port to use to connect to the database server
* database
* username
* password
* max\_active: used to set the maxActive context parameter
* max\_idle: used to set the maxIdle context parameter
* max\_wait: used to set the maxWait context parameter

You can invoke any other method on the database block, which will result in an entry being created in the `@database` Hash which is passed to the context template. See the examples below for more information.

tomcat
------

The `tomcat` sub-resource LWRP configures Tomcat to run the application by creating a symbolic link to the context file.

Attributes
==========

scm\_provider
------------

Supports all standard scm providers (git, svn), and in addition:
*	Chef::Provider::RemoteFile::Deploy allows downloading from a remote url
*	Chef::Provider::File::Deploy allows using a package on the filesystem

path
----

The target location for the application distribution. This should be outside of the tomcat deployment tree.

repository
----------

For a git or svn repository, it is the repository URL
When using Chef::Provider::RemoteFile::Deploy, it is the URL of the remote file
When using Chef::Provider::File::Deploy, it is the path to the local file source

revision
--------

Name of the path within releases, defaults to the checksum of the downloaded file

Usage
=====

A sample application that needs a database connection:

    application "my-app" do
      path "/usr/local/my-app"
      repository "/nas/distro/my-app.war"
      revision "..."
			scm_provider Chef::Provider::File::Deploy

      java_webapp do
        database_master_role "database_master"
        database do
          driver 'org.gjt.mm.mysql.Driver'
          database 'name'
          port 5678
          username 'user'
          password 'password'
          max_active 1
          max_idle 2
          max_wait 3
        end
      end

      tomcat
    end

If your application does not need a database connection (or you need a custom
context file for other reasons), you can specify your own template:

    application "jenkins" do
      path "/usr/local/jenkins"
      owner node["tomcat"]["user"]
      group node["tomcat"]["group"]
      repository "http://mirrors.jenkins-ci.org/war/latest/jenkins.war"
      revision "6facd94e958ecf68ffd28be371b5efcb5584c885b5f32a906e477f5f62bdb518-1"
			scm_provider Chef::Provider::RemoteFile::Deploy

      java_webapp do
        context_template "jenkins-context.xml.erb"
      end

      tomcat
    end

You can invoke any method on the database block:

    application "my-app" do
      path "/usr/local/my-app"
      repository "..."
      revision "..."

      java_webapp do
        database_master_role "database_master"
        database do
          database 'name'
          quorum 2
          replicas %w[Huey Dewey Louie]
        end
      end
    end

The corresponding entries will be passed to the context template:

    <Context docBase="<%= @war %>" path="/">
      <!-- <%= @database['quorum'] %> -->
      <!-- <%= @database['replicas'].join(',') %> -->
    </Context>

License and Author
==================

Author:: Adam Jacob (<adam@opscode.com>)
Author:: Andrea Campi (<andrea.campi@zephirworks.com>)
Author:: Jesse Campbell (<hikeit@gmail.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright 2009-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
