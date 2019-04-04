resource_name :ngx_http_ssl_module

property :openssl_version, [String, NilClass], default: nil
property :openssl_url_template, String, default: 'https://www.openssl.org/source/openssl-%{version}.tar.gz'
property :openssl_checksum, [String, NilClass], default: nil

default_action :add

action :add do
  configure_flags = %w[--with-http_ssl_module]
  install_openssl = !(new_resource.openssl_version.nil? || new_resource.openssl_checksum.nil?)

  if install_openssl
    download_url = format(new_resource.openssl_url_template, version: new_resource.openssl_version)
    tarball_name = ::File.basename(download_url)
    tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
    extract_path = ::File.join(::Chef::Config['file_cache_path'], "openssl-#{new_resource.openssl_version}")

    remote_file tarball_path do
      source download_url
      checksum new_resource.openssl_checksum
      action :create
    end

    bash 'extract openssl' do
      cwd  ::File.dirname(tarball_path)
      code <<-EOH
        mkdir -p #{extract_path}
        tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
      EOH
      action :run
      not_if { ::File.exist?(extract_path) }
    end

    configure_flags << "--with-openssl=#{extract_path}"
  end

  nginx_module 'http_ssl' do
    packages(%w[openssl libssl-dev]) unless install_openssl
    flags configure_flags
    action :add
  end
end
