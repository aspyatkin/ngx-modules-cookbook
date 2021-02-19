resource_name :ngx_lua_module
provides :ngx_lua_module

property :version, String, default: '0.10.14'
property :url_template, String, default: 'https://github.com/openresty/lua-nginx-module/archive/v%{version}.tar.gz'
property :checksum, String, default: '9e17e086d0ac74fb72326abb7f2f8274c080b4981cbf358b026307b4088e7148'

property :luajit_version, String, default: '0bf80b07b0672ce874feedcc777afe1b791ccb5a'
property :luajit_url_template, String, default: 'https://repo.or.cz/luajit-2.0.git/snapshot/%{version}.tar.gz' # default: 'http://luajit.org/download/LuaJIT-%{version}.zip'
property :luajit_checksum, String, default: 'ffa049ade31e6c0a00d94d3ae5923d93dedafa011c129911314ecf145c2e544f' # default: '874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979'

default_action :add

action :add do
  luajit_download_url = format(new_resource.luajit_url_template, version: new_resource.luajit_version)
  luajit_tarball_name = ::File.basename(luajit_download_url)
  luajit_tarball_path = ::File.join(::Chef::Config['file_cache_path'], luajit_tarball_name)
  luajit_extract_path = ::File.join(::Chef::Config['file_cache_path'], "luajit-#{new_resource.luajit_version}")

  remote_file luajit_tarball_path do
    source luajit_download_url
    checksum new_resource.luajit_checksum
    action :create
  end

  bash 'extract and build luajit' do
    cwd  ::File.dirname(luajit_tarball_path)
    code <<-EOH
      mkdir -p #{luajit_extract_path}
      tar xzf #{luajit_tarball_name} -C #{luajit_extract_path} --strip-components 1
      cd #{luajit_extract_path}
      make && make install
    EOH
    action :run
    not_if { ::File.exist?(luajit_extract_path) }
  end

  download_url = format(new_resource.url_template, version: new_resource.version)
  tarball_name = ::File.basename(download_url)
  tarball_path = ::File.join(::Chef::Config['file_cache_path'], tarball_name)
  extract_path = ::File.join(::Chef::Config['file_cache_path'], "ngx_lua_module-#{new_resource.version}")

  remote_file tarball_path do
    source download_url
    checksum new_resource.checksum
    action :create
  end

  bash 'extract ngx_lua_module' do
    cwd  ::File.dirname(tarball_path)
    code <<-EOH
      mkdir -p #{extract_path}
      tar xzf #{tarball_name} -C #{extract_path} --strip-components 1
    EOH
    action :run
    not_if { ::File.exist?(extract_path) }
  end

  nginx_module 'ngx_lua_module' do
    flags [
      "--add-module=#{extract_path}",
      '--with-ld-opt=-Wl,-rpath,/usr/local/lib',
    ]
    env_vars({
      'LUAJIT_INC' => '/usr/local/include/luajit-2.0',
      'LUAJIT_LIB' => '/usr/local/lib',
    })
    action :add
  end
end
