resource_name :ngx_set_misc_module

property :version, String, default: '0.32'
property :url_template, String, default: 'https://github.com/openresty/set-misc-nginx-module/archive/v%{version}.tar.gz'
property :checksum, String, default: 'f1ad2459c4ee6a61771aa84f77871f4bfe42943a4aa4c30c62ba3f981f52c201'

default_action :add

action :add do
  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_set_misc-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_set_misc' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_set_misc' do
    flags %W[--add-module=#{extract_path}]
    action :add
  end
end
