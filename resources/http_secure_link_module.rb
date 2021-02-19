resource_name :ngx_http_secure_link_module
provides :ngx_http_secure_link_module

default_action :add

action :add do
  nginx_module 'http_secure_link' do
    flags '--with-http_secure_link_module'
    action :add
  end
end
