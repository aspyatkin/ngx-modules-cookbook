resource_name :ngx_devel_kit

property :version, String, default: '0.3.0'
property :url_template, String, default: 'https://github.com/simpl/ngx_devel_kit/archive/v%{version}.tar.gz'
property :checksum, String, default: '88e05a99a8a7419066f5ae75966fb1efc409bad4522d14986da074554ae61619'

default_action :add

action :add do
  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_devel_kit-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_devel_kit' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_devel_kit' do
    flags %W[--add-module=#{extract_path}]
    action :add
  end
end
