FROM php:7.1

RUN apt-get clean && apt-get update &&  \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get -y install git &&  \
    apt-get install -y build-essential && \
    apt-get install -my wget gnupg

COPY . /omp
WORKDIR /omp

RUN git submodule update --init --recursive
RUN cp config.TEMPLATE.inc.php config.inc.php

#NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

WORKDIR lib/pkp

RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar update

RUN npm install
RUN npm run build

WORKDIR /omp
RUN mkdir uploaded_files

RUN chmod 777 config.inc.php
RUN chmod -R 777 public/
RUN chmod -R 777 cache/

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000"]
