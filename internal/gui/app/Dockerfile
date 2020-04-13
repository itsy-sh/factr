FROM node:12.16.2

RUN yarn global add parcel-bundler

RUN curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz && \
    gunzip elm.gz && \
    chmod +x elm && \
    mv elm /usr/local/bin/


WORKDIR /app

CMD yarn install && parcel serve index.html