#!/bin/bash
echo "[INFO] Installing apache service"
echo "[INFO] Current working dir is: `pwd`"
echo "[INFO] Installing httpd service" 

# checking for hhtpd service
which httpd
if [ "$?" == 0 ]; then
	echo "[INFO] httpd service is installed"	
	if sudo bash -c '[[ -f "/var/run/httpd/httpd.pid" ]]'; then
		echo "[INFO] httpd service is running on" - `sudo cat /var/run/httpd/httpd.pid`
		echo "[INFO] Stopping HTTPD"
		sudo service httpd stop
		if sudo bash -c '[[ ! -f "/var/run/httpd/httpd.pid" ]]'; then
			echo "[WARNING] Successfully stopped httpd"
		else
			echo "[WARNING]: Killing httpd PID"
			sudo kill -9 `sudo cat /var/run/httpd/httpd.pid`
		fi
	else 
		echo "[ERROR] apache services are installed but not started"
	fi
else
	echo "[ERROR] apache services are not installed"
	echo "[INFO] Try to installating HTTPD"
	sudo yum -y install httpd
	which httpd
	if [ "$?" == 0 ]; then
		echo "[INFO] successfully installed"
	else
		echo "[ERROR] not able to install. please check configuration file"
	fi
fi

echo "[INFO]: Creating vhost config file "
sudo bash -c '[[ -f /etc/httpd/conf.d/vhost.conf ]] && rm -f /etc/httpd/conf.d/vhost.conf '
sudo tee -a /etc/httpd/conf.d/vhost.conf > /dev/null <<EOT
<VirtualHost *:80>
    ServerAdmin silpa@gmail.com
    ServerName silpa.com
    ServerAlias www.silpa.com
    DocumentRoot /var/www/html/silpa.com/
    ErrorLog /var/log/httpd/silpa.com/error.log
    CustomLog /var/log/httpd/silpa.com/access.log combined
</VirtualHost>
EOT

#echo "creating directories"
sudo bash -c '[[ -d /var/www/html/silpa.com ]] || mkdir /var/www/html/silpa.com '

#sudo mkdir /var/www/html/silpa.com

sudo bash -c '[[ -d /var/log/httpd/silpa.com ]] || mkdir /var/log/httpd/silpa.com '

#sudo mkdir /var/log/httpd/silpa.com


sudo tee -a  /var/www/html/silpa.com/index.html > /dev/null <<EOF
Welcome to My first Website
EOF

echo "[INFO] starting httpd"
sudo service httpd start 

echo "[INFO] checking pid file"
echo "[INFO] httpd service is running on" - `sudo cat /var/run/httpd/httpd.pid`
