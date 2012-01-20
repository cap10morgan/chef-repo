maintainer       "Wes Morgan"
maintainer_email "wes@turbovote.org"
license          "Apache 2.0"
description      "Sets up environment for turbovote Rails app"
version          "0.1.0"

recipe "turbovote", "Sets up app and database for turbovote Rails app"
recipe "turbovote::app", "Sets up user and filesystem for turbovote Rails app"
recipe "turbovote::database", "Sets up MySQL database and privileges for turbovote Rails app"
recipe "turbovote::create_user", "Creates and configures the account used to deploy the app"

depends "mysql"

%w{ ubuntu debian }.each do |os|
  supports os
end
