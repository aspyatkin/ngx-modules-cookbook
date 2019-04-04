resource_name :ngx_http_stub_status_module

default_action :add

action :add do
  nginx_module 'http_stub_status' do
    flags %w[--with-http_stub_status_module]
    action :add
  end
end
