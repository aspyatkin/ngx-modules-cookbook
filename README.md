# ngx-modules cookbook
[![Chef cookbook](https://img.shields.io/cookbook/v/ngx-modules.svg?style=flat-square)]()
[![license](https://img.shields.io/github/license/aspyatkin/ngx-modules-cookbook.svg?style=flat-square)]()  
Configure [nginx](http://nginx.org) web server modules for [ngx](https://github.com/aspyatkin/ngx-cookbook) cookbook.

## Resources

- [ngx_http_ssl_module](https://nginx.ru/en/docs/http/ngx_http_ssl_module.html)
- [ngx_http_v2_module](https://nginx.org/en/docs/http/ngx_http_v2_module.html)
- [ngx_http_realip_module](https://nginx.org/en/docs/http/ngx_http_realip_module.html)
- [ngx_http_stub_status_module](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html)
- [ngx_http_gzip_static_module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)
- [ngx_http_dav_module](https://nginx.org/en/docs/http/ngx_http_dav_module.html)
- [ngx_http_secure_link_module](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html)
- [ngx_http_image_filter_module](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html)
- [ngx_http_js_module](http://nginx.org/en/docs/http/ngx_http_js_module.html)
- [ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
- [ngx_devel_kit](https://github.com/simplresty/ngx_devel_kit)
- [ngx_lua_module](https://github.com/openresty/lua-nginx-module)
- [ngx_set_misc_module](https://github.com/openresty/set-misc-nginx-module)
- [ngx_headers_more_module](https://github.com/openresty/headers-more-nginx-module)
- [ngx_brotli_module](https://github.com/eustas/ngx_brotli)
- [ngx_cache_purge_module](https://github.com/nginx-modules/ngx_cache_purge)
- [ngx_http_dav_ext_module](https://github.com/arut/nginx-dav-ext-module)

## Usage

```ruby
ngx_http_ssl_module 'default' do
  # install the latest version of OpenSSL
  openssl_version '1.1.1b'
  openssl_checksum '5c557b023230413dfb0756f3137a13e6d726838ccd1430888ad15bfb2b43ea4b'
  action :add
end

ngx_http_v2_module 'default'
ngx_http_realip_module 'default'
ngx_http_stub_status_module 'default'
ngx_http_gzip_static_module 'default'
ngx_http_dav_module 'default'
ngx_http_dav_ext_module 'default'
ngx_http_secure_link_module 'default'
ngx_http_image_filter_module 'default'
ngx_http_js_module 'default'
ngx_http_geoip2_module 'default'
ngx_devel_kit 'default'
ngx_lua_module 'default'
ngx_set_misc_module 'default'
ngx_headers_more_module 'default'
ngx_brotli_module 'default'
ngx_cache_purge_module 'default'

nginx_install 'default' do
  action :run
end
```

## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
