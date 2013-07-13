default['mini-dinstall']['user'] = "apt"
default['mini-dinstall']['group'] = "apt"
default['mini-dinstall']['comment'] = "apt"
default['mini-dinstall']['homedir'] = "/srv/apt"
default['mini-dinstall']['archivedir'] = default['mini-dinstall']['homedir'] + "/public_html/apt/"
default['mini-dinstall']['contact'] = "infrastructure@openenglish.com"
default['mini-dinstall']['gpg_realname'] = "APT Open English Repository"

default['mini-dinstall']['release_origin'] = "openenglish"
default['mini-dinstall']['release_label'] = "openenglish"
default['mini-dinstall']['release_description'] = "Unofficial Debian packages maintained by Open English Infrastructure team"

default['mini-dinstall']['http_port'] = "80";
default['mini-dinstall']['autoindex'] = "on";
default['mini-dinstall']['server_name'] = "apt";
default['mini-dinstall']['apt_vhost'] = "/etc/nginx/sites-available/apt"
default['mini-dinstall']['apt_enabled_vhost'] = "/etc/nginx/sites-enabled/apt"

