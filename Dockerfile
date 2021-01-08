FROM node:12.20-buster-slim AS node_base
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

FROM ruby:2.7-slim
COPY --from=node_base . .
LABEL Alessio Caradossi <alkcxy@gmail.com>
RUN mkdir /bibliogo
WORKDIR /bibliogo
RUN apt-get update && apt-get upgrade -y && apt-get install -y -qq curl gnupg --fix-missing --no-install-recommends
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -qq -y build-essential yarn --fix-missing --no-install-recommends
RUN apt-get autoremove -y
COPY . /bibliogo
RUN gem update bundle
RUN bundle install && yarn install