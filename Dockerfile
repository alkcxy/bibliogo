FROM node:12.20-buster-slim AS node_base
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

FROM ruby:2.7-slim
COPY --from=node_base . .
LABEL Alessio Caradossi <alkcxy@gmail.com>
RUN mkdir /bibliogo
WORKDIR /bibliogo
# ruby:2.7-slim is Debian bullseye, archived: use archive.debian.org
RUN rm -f /etc/apt/sources.list.d/* /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian bullseye main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get -o Acquire::Check-Valid-Until=false upgrade -y -qq && apt-get install -y -qq curl gnupg --fix-missing --no-install-recommends
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -qq -y build-essential yarn --fix-missing --no-install-recommends
RUN apt-get autoremove -y
COPY . /bibliogo
RUN gem update bundle
RUN bundle install && yarn install