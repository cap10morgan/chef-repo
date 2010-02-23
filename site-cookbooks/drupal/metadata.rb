maintainer        "Wes Morgan"
maintainer_email  "cap10morgan@gmail.com"
license           "Apache 2.0"
description       "Installs Drupal from drupal.org"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.1"

%w{ mysql apache2 php }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end

