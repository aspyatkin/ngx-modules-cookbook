name 'ngx-modules'
maintainer 'Alexander Pyatkin'
maintainer_email 'aspyatkin@gmail.com'
license 'MIT'
version '1.3.3'
description 'Configure nginx web server modules'

source_url 'https://github.com/aspyatkin/ngx-modules-cookbook'

supports 'ubuntu'

chef_version '>= 12'
supports 'debian', '>= 8.0'
supports 'ubuntu', '>= 16.04'

depends 'ngx', '>= 2.2.0'
