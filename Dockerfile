FROM php:7.1

RUN apt-get clean && apt-get update &&  \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get -y install git &&  \
    apt-get install -y build-essential && \
    apt-get install -my wget gnupg && \
    apt-get install -y libxslt-dev && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install xsl

#NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

#Composer
RUN curl -sS https://getcomposer.org/installer | php

WORKDIR /omp

COPY composer.phar /omp
COPY composer.json /omp
COPY composer.lock /omp
COPY package.json /omp
COPY webpack.config.js /omp

RUN php composer.phar install

RUN mkdir uploaded_files

COPY config.TEMPLATE.inc.php config.inc.php

COPY . /omp

RUN git submodule update --init --recursive

RUN npm install
RUN npm run build

RUN chmod 777 config.inc.php
RUN chmod -R 777 public/
RUN chmod -R 777 cache/

COPY config/php.ini /usr/local/etc/php/

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000"]
