# Replacing nginx config
for project_dir in /var/www/*; do
    if [ -d "$project_dir" ]; then
        project_name=$(basename "$project_dir")
	
	sed -e "s/{PROJECTNAME}/$project_name/g" /etc/nginx/conf.d/default.conf.tmpl > "/etc/nginx/sites-available/$project_name.conf"
	
	ln -s "/etc/nginx/sites-available/$project_name.conf" "/etc/nginx/sites-enabled/$project_name.conf"
	
    fi
done

#start the nginx
service nginx start

#!/bin/bash
#Start the supervisor
supervisord -n -c /etc/supervisor/supervisord.conf

