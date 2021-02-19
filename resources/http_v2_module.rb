resource_name :ngx_http_v2_module
provides :ngx_http_v2_module

default_action :add

action :add do
  nginx_module 'http_v2' do
    flags ['--with-http_v2_module']
    action :add
  end
end
