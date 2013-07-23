name             "application_java"
maintainer       "ZephirWorks"
maintainer_email "andrea.campi@zephirworks.com"
license          "Apache 2.0"
description      "Deploys and configures Java-based applications"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.0.1"

%w{ java tomcat }.each do |cb|
  depends cb
end

depends "application", "~> 3.0"
