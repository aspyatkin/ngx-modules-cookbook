resource_name :ngx_http_dav_ext_module

property :version, String, default: '3.0.0'
property :url_template, String, default: 'https://github.com/arut/nginx-dav-ext-module/archive/v%{version}.tar.gz'
property :checksum, String, default: 'd2499d94d82d4e4eac8425d799e52883131ae86a956524040ff2fd230ef9f859'
default_action :add

action :add do
  package 'libxml2-dev'
  package 'libxslt1-dev'

  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_http_dav_ext-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_http_dav_ext' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_http_dav_ext' do
    flags %W[--add-module=#{extract_path}]
    action :add
  end
end
