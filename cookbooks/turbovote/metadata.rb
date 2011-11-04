maintainer       "Wes Morgan"
maintainer_email "wes@timetraveltoaster.com"
license          "Apache 2.0"
description      "Sets up environment for turbovote Rails app"
version          "0.0.1"

recipe "turbovote::app", "Sets up user and filesystem for turbovote Rails app"
recipe "turbovote::database", "Sets up MySQL database and privileges for turbvote Rails app"

depends "mysql"

%w{ ubuntu debian }.each do |os|
  supports os
end
