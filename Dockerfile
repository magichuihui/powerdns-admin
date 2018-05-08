FROM ubuntu:latest
MAINTAINER kyra "magichuihui@gmail.com"
ARG ENVIRONMENT=development
ENV ENVIRONMENT=${ENVIRONMENT}

WORKDIR /powerdns-admin

RUN apt-get update -y \
    && apt-get install -y python3-pip python3-dev supervisor \
    # lib for building mysql db driver
    libmysqlclient-dev \
    # lib for buiding ldap and ssl-based application
    libsasl2-dev libldap2-dev libssl-dev \
    # lib for building python3-saml
    libxml2-dev libxslt1-dev libxmlsec1-dev libffi-dev pkg-config \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /powerdns-admin/requirements.txt
RUN pip3 install -r requirements.txt

ADD ./supervisord.conf /etc/supervisord.conf
ADD . /powerdns-admin/
COPY ./configs/${ENVIRONMENT}.py /powerdns-admin/config.py
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
