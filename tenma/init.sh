#!/bin/bash
python3 manage.py generatesecretkey
if [ -e files/db.sqlite3 ]
then
	python3 manage.py migrate
else
	python3 manage.py migrate
	echo "from django.contrib.auth.models import User; User.objects.filter(email='admin@example.com').delete(); User.objects.create_superuser('admin', 'admin@example.com', 'Pegasus!')" | python3 ./manage.py shell
fi
supervisord --nodaemon --configuration /etc/supervisord.conf
