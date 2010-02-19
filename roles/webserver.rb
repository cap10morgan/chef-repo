name "webserver"
description "The base role for web servers"
recipes "apache2", "apache2::mod_ssl"
default_attributes "apache2" => { "listen_ports" => [ "80", "443" ] }
override_attributes "apache2" => { "max_children" => "50" }
