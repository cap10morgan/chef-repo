maintainer       "Wes Morgan"
maintainer_email "wes@turbovote.org"
license          "Apache 2.0"
version          "0.0.1"

recipe "tvblog", "Installs WordPress & TurboVote theme"
recipe "tvblog::wp-theme", "Installs TurboVote WordPress theme"

depends "wordpress"

%w{ ubuntu debian }.each do |os|
  supports os
end
