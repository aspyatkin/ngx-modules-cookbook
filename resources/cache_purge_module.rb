resource_name :ngx_cache_purge_module
provides :ngx_cache_purge_module

property :version, String, default: '2.5'
property :url_template, String, default: 'https://github.com/nginx-modules/ngx_cache_purge/archive/%{version}.tar.gz'
property :checksum, String, default: '2df8501c7ffcac44d4932939faa686fc3cc56e05cfc05bc411bda3313b05dbdd'
default_action :add

action :add do
  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_cache_purge-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_cache_purge' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_cache_purge' do
    flags "--add-module=#{extract_path}"
    action :add
  end
end
