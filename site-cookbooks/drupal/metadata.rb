maintainer        "Wes Morgan"
maintainer_email  "cap10morgan@gmail.com"
license           "Apache 2.0"
description       "Installs Drupal 6 from the Debian/Ubuntu apt repository"
version           "0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end

