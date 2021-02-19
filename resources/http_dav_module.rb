resource_name :ngx_http_dav_module
provides :ngx_http_dav_module

default_action :add

action :add do
  nginx_module 'http_dav' do
    flags '--with-http_dav_module'
    action :add
  end
end
