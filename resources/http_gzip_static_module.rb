resource_name :ngx_http_gzip_static_module
provides :ngx_http_gzip_static_module

default_action :add

action :add do
  nginx_module 'http_gzip_static' do
    flags '--with-http_gzip_static_module'
    action :add
  end
end
