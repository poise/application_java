Description
===========

Requirements
============

Attributes
==========

Usage
=====

A sample application that needs a database connection:

    application "my-app" do
      path "/usr/local/my-app"
      repository "..."
      revision "..."

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

      java_webapp do
        context_template "jenkins-context.xml.erb"
        database_master_role "database_master"  # FIXME
      end

      tomcat
    end
