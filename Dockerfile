FROM php:5.6

RUN apt-get clean && apt-get update && apt-get -y install git && apt-get install -y nodejs && apt-get install -y build-essential && apt-get install -y npm

WORKDIR /var/omp

RUN git submodule update --init --recursive
RUN cp config.TEMPLATE.inc.php config.inc.php
RUN cd lib/pkp

RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar install

RUN npm install
RUN npm run build

CMD ["php", "-S", "0.0.0.0:80"]
