resource_name :ngx_http_js_module

property :version, String, default: '0.3.0'
property :url_template, String, default: 'https://github.com/nginx/njs/archive/%{version}.tar.gz'
property :checksum, String, default: 'dc63bfd1be4f48a40cd667629f3dcf51c58d4f1b189aa127e352aa5193436066'

default_action :add

action :add do
  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_http_js-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_http_js' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_http_js' do
    flags %W[--add-module=#{::File.join(extract_path, 'nginx')}]
    action :add
  end
end
