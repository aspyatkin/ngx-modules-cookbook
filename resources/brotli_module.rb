resource_name :ngx_brotli_module
provides :ngx_brotli_module

property :version, String, default: 'v1.0.0rc'
property :url, String, default: 'https://github.com/google/ngx_brotli'

default_action :add

action :add do
  src_name = "ngx_brotli-#{new_resource.version}"
  src_dir = ::File.join(::Chef::Config['file_cache_path'], src_name)

  directory src_dir do
    action :create
  end

  git src_dir do
    repository new_resource.url
    revision new_resource.version
    enable_checkout false
    enable_submodules true
    action :sync
  end

  nginx_module 'ngx_brotli' do
    flags "--add-module=#{src_dir}"
    action :add
  end
end
