server {
    listen  80;

    root {{ nginx.docroot }};
    index index.php;

    server_name {{ nginx.servername }};

    location / {
        rewrite ^/(.*)/$ /$1 permanent;
        try_files $uri $uri/ @rewrites;
    }
    location ~* web/js(.*)$ {
        rewrite ^/(.*\.js)$ /combine.php?type=js&files=$1;
    }
    location ~* web/css(.*)$ {
        rewrite ^/(.*\.css)$ /combine.php?type=css&files=$1;
    }
    location ~ \.php {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_param PATH_INFO $fastcgi_script_name;
    }
    location @rewrites {
        if ($request_uri !~ "/(index\.php)") {
            rewrite ^/(.*)$ /index.php/$1 last;
        }
    }

    error_page 404 /404.html;

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        root /usr/share/nginx/www;
    }
}
