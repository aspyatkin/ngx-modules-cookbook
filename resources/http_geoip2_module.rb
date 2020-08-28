resource_name :ngx_http_geoip2_module

property :version, String, default: '3.3'
property :url_template, String, default: 'https://github.com/leev/ngx_http_geoip2_module/archive/%{version}.tar.gz'
property :checksum, String, default: '41378438c833e313a18869d0c4a72704b4835c30acaf7fd68013ab6732ff78a7'

property :apt_repository_uri, String, default: 'ppa:maxmind/ppa'
property :apt_packages, Array, default: %w[
  libmaxminddb0
  libmaxminddb-dev
  mmdb-bin
]
property :apt_upgrade, [TrueClass, FalseClass], default: false

default_action :add

action :add do
  case node['platform_family']
  when 'debian'
    apt_repository 'maxmind' do
      uri new_resource.apt_repository_uri
      distribution node['lsb']['codename']
      components ['main']
      action :add
    end

    new_resource.apt_packages.each do |pkg_name|
      package pkg_name do
        action (new_resource.apt_upgrade ? 'upgrade' : 'install').to_sym
      end
    end
  end

  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_http_geoip2-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_http_geoip2' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_http_geoip2' do
    flags %W[--add-module=#{extract_path}]
    action :add
  end
end
