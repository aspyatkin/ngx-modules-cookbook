resource_name :ngx_http_image_filter_module
provides :ngx_http_image_filter_module

default_action :add

action :add do
  nginx_module 'http_image_filter' do
    packages %w[libgd-dev]
    flags '--with-http_image_filter_module'
    action :add
  end
end
