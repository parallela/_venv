#start the nginx
service nginx start


#!/bin/bash
#Start the supervisor
supervisord -n -c /etc/supervisor/supervisord.conf

#starting php-fpm
php-fpm

