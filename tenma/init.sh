#!/bin/bash
python3 manage.py generatesecretkey
if [ ! -d $TENMA_CONFIG_DIR/CACHE/ ]
then
	mkdir $TENMA_CONFIG_DIR/CACHE
fi
if [ ! -d $TENMA_CONFIG_DIR/images/ ]
then
	mkdir $TENMA_CONFIG_DIR/images
fi
if [ ! -d $TENMA_CONFIG_DIR/temp/ ]
then
	mkdir $TENMA_CONFIG_DIR/temp
fi
if [ -e $TENMA_CONFIG_DIR/db.sqlite3 ]
then
	python3 manage.py migrate
else
	python3 manage.py migrate
	echo "from django.contrib.auth.models import User; User.objects.filter(email='admin@example.com').delete(); User.objects.create_superuser('admin', 'admin@example.com', 'Pegasus!')" | python3 ./manage.py shell
fi
supervisord --nodaemon --configuration /etc/supervisord.conf
