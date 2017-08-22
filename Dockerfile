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
ENV TENMA_CONFIG_DIR=/tenma/media
ENV TENMA_UNRAR_PATH=/usr/bin/unrar

RUN \
	# Install alpine packages
	apk add --no-cache python3-dev curl unzip jpeg-dev zlib-dev gcc make g++ redis supervisor unrar bash && \

	# Download and unpack Tenma
	mkdir $TENMA_INSTALL_DIR && \
	curl -o $TENMA_INSTALL_DIR/tenma.zip "https://codeload.github.com/hmhrex/Tenma/zip/v0.1.11-alpha" && \
	unzip $TENMA_INSTALL_DIR/tenma.zip -d /tenma && \
	mv $TENMA_INSTALL_DIR/Tenma-0.1.11-alpha/* /tenma/ && \
	rm -f $TENMA_INSTALL_DIR/tenma.zip && \
	rm -rf $TENMA_INSTALL_DIR/Tenma-0.1.11-alpha && \

	# Upgrade pip and install setuptools
	pip3 install --upgrade pip setuptools && \
	if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
	rm -r /root/.cache && \

	# Install Tenma requirements
	pip3 install -r $TENMA_INSTALL_DIR/requirements.txt && \
	pip3 install redis && \

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

COPY /tenma/init.sh /
RUN chmod +x /init.sh

VOLUME $TENMA_MEDIA_DIR
VOLUME $TENMA_CONFIG_DIR
WORKDIR $TENMA_INSTALL_DIR
EXPOSE 8000

CMD ["bash", "/init.sh"]
