FROM alpine:3.6

MAINTAINER Harley Hicks "harley@hicks.house"
#	TODO:
#	- Install and configure NGNIX and Gunicorn

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONUNBUFFERED 1
ENV C_FORCE_ROOT true
ENV PATH /usr/local/bin:$PATH
ENV LIBRARY_PATH=/lib:/usr/lib
ENV TENMA_INSTALL_DIR=/tenma
ENV TENMA_MEDIA_DIR=/tenma/files

RUN \
	# Install alpine packages
	apk add --no-cache python3-dev curl unzip jpeg-dev zlib-dev gcc make g++ redis supervisor && \

	# Download and unpack Tenma
	mkdir $TENMA_INSTALL_DIR && \
	curl -o $TENMA_INSTALL_DIR/tenma.zip "https://codeload.github.com/hmhrex/Tenma/zip/v0.1.1-alpha" && \
	unzip $TENMA_INSTALL_DIR/tenma.zip -d /tenma && \
	mv $TENMA_INSTALL_DIR/Tenma-0.1.1-alpha/* /tenma/ && \
	rm -f $TENMA_INSTALL_DIR/tenma.zip && \
	rm -rf $TENMA_INSTALL_DIR/Tenma-0.1.1-alpha && \

	# Upgrade pip and install setuptools
	pip3 install --upgrade pip setuptools && \
	if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
	rm -r /root/.cache && \

	# Install Tenma requirements
	pip3 install -r $TENMA_INSTALL_DIR/requirements.txt && \
	pip3 install redis && \

	# Migrate database
	python3 /tenma/manage.py migrate && \

	# Create the default user
	echo "from django.contrib.auth.models import User; User.objects.filter(email='admin@example.com').delete(); User.objects.create_superuser('admin', 'admin@example.com', 'Pegasus!')" | python3 /tenma/manage.py shell && \

	# Fix ownership
	set -x ; addgroup -g 82 -S www-data ; \
	adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1 && \
	chown -R www-data:www-data $TENMA_INSTALL_DIR && \

	# Remove default configurations
	rm /tenma/tenma/settings.py && \
	rm /etc/supervisord.conf

COPY /tenma/tenma/settings.py /tenma/tenma
COPY /etc/supervisord.conf /etc/
COPY /etc/supervisor/conf.d/redis.conf /etc/supervisor/conf.d/
COPY /etc/supervisor/conf.d/celery.conf /etc/supervisor/conf.d/
COPY /etc/supervisor/conf.d/tenma.conf /etc/supervisor/conf.d/

VOLUME $TENMA_MEDIA_DIR
WORKDIR $TENMA_INSTALL_DIR
EXPOSE 8000

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
