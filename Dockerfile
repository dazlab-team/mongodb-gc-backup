FROM google/cloud-sdk:alpine

RUN apk add --update \
  mongodb-tools \
  curl \
  python3 \
  py-pip \
  py-cffi \
  && pip install --upgrade pip \
  && apk add --virtual build-deps \
  gcc \
  libffi-dev \
  python3-dev \
  linux-headers \
  musl-dev \
  openssl-dev \
  cargo \
  && apk del build-deps \
  && rm -rf /var/cache/apk/*

ADD ./run.sh /mongodb-gc-backup/run.sh
WORKDIR /mongodb-gc-backup/

RUN chmod +x /mongodb-gc-backup/run.sh

CMD ["/mongodb-gc-backup/run.sh"]