resource_name :ngx_http_realip_module
provides :ngx_http_realip_module

default_action :add

action :add do
  nginx_module 'http_realip' do
    flags '--with-http_realip_module'
    action :add
  end
end
