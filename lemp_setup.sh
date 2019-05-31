#!/usr/bin/env bash

#If error use dos2unix lemp_setup.sh before running

clear

function create_sudo_user(){
    read -p "Set sudo user: " username;
    (adduser $username && usermod -aG sudo $username);
}

function install_nginx(){
    echo "Installing nginx...";
    (sudo apt update && sudo apt install nginx);
    echo "Setting up ufw...";
    (sudo ufw app list && sudo ufw allow ssh && sudo ufw allow 22 &&  sudo ufw allow 80 && sudo ufw allow 443 && sudo ufw allow 'Nginx Full' && sudo ufw enable && sudo ufw status verbose);
}

function install_mariadb(){
    echo "Installing MariaDB...";
    (sudo ufw allow 3306);
    (sudo apt update);
    (sudo apt install mariadb-server);
    #sudo systemctl status mariadb
    echo "Checking version...";
    (mysql -V);
    echo "Securing MariaDB...";
    (sudo mysql_secure_installation);
    read -p "Bind address to 0.0.0.0 and uncomment port 3306...";
    (sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf);
    (sudo systemctl restart mysql.service && sudo systemctl restart mariadb.service);
}

function setup_mariadb_user(){
    #(sudo mysql -e 'SELECT user,authentication_string,plugin,host FROM mysql.user;');
    #(mysql --host=localhost --user=root --password=xxxxxx  -e "source dbscript.sql");
    read -p "Enter root password to continue: " rootpass;
    read -p "Create username (no spaces): " username;
    read -p "Create user password (no spaces): " pass;
    (mysql --host=localhost --user=root --password=$rootpass  -e "CREATE USER '$username'@'%' IDENTIFIED BY '$pass'; GRANT ALL PRIVILEGES ON * . * TO '$username'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;");
}

function install_php(){
    echo "Installing dependencies...";
    (sudo add-apt-repository universe);
    echo "Installing PHP...";
    (sudo apt install php-fpm php-mysql);
}


function setup_nginx_serverblock(){
    read -p "Domain or dot com: " domain;
    (sudo mkdir -p /var/www/$domain/html && sudo chown -R $USER:$USER /var/www/$domain/html && sudo chmod -R 755 /var/www/$domain);
    echo "Creating initial html...";
    (cd /var/www/$domain/html && echo "<title>$domain</title>
    </head>
    <body>
        <h1>Success!  The $domain server block is working!</h1>
    </body>
    </html>" > index.html);
    echo "Creating initial php...";
    (cd /var/www/$domain/html && echo "<?php
    phpinfo();" > info.php);
    echo "Creating nginx sites available file...";
    (cd /etc/nginx/sites-available && echo "server {
        listen 80;
        listen [::]:80;

        root /var/www/$domain/html;
        index index.php index.html index.htm index.nginx-debian.html;

        server_name $domain;

        location / {
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.
            try_files \$uri \$uri/ =404;
        }

        location ~ \.php\$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
    }" > $domain);
    echo "Creating symlink...";
    (sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/);
    read -p "Uncomment 'server_names_hash_bucket_size' & restart nginx...";
    (sudo nano /etc/nginx/nginx.conf);
}

function restart_nginx_service(){
    echo "Testing nginx...";
    (sudo nginx -t);
    echo "Restarting nginx service...";
    (sudo systemctl restart nginx);
}

function install_certbot(){
    echo "Installing certbot...";
    (sudo add-apt-repository ppa:certbot/certbot);
    echo "Installing python certbot for nginx...";
    (sudo apt install python-certbot-nginx);
}

function get_ssl(){
    read -p "Domain or dot com: " domain;
    (sudo certbot --nginx -d $domain);
    echo "Verifying auto-renewal process...";
    (sudo certbot renew --dry-run);
}


echo "Which would you like to do?"
select pd in "install_nginx" "install_mariadb" "setup_mariadb_user" "setup_nginx_serverblock" "restart_nginx_service" "install_certbot" "get_ssl"  "create_sudo_user" "exit"; do 
    case $pd in 
        install_nginx ) install_nginx; exit;;
        install_mariadb ) install_mariadb; exit;;
        setup_mariadb_user ) setup_mariadb_user; exit;;
        setup_nginx_serverblock ) setup_nginx_serverblock; exit;;
        restart_nginx_service ) restart_nginx_service; exit;;
        install_certbot ) install_certbot; exit;;
        get_ssl ) get_ssl; exit;;
        create_sudo_user ) create_sudo_user; exit;;
        exit ) exit;;
    esac
done
