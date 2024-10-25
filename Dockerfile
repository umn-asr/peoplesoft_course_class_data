ARG RUBY_VERSION="3.1.6"

### base ###
FROM ruby:$RUBY_VERSION-slim AS base

ARG GID=1000
ARG UID=1000

ENV HOME="/home/app"
ENV NLS_LANG="AMERICAN_AMERICA.WE8ISO8859P1"
ENV TZ="America/Chicago"

WORKDIR $HOME

# configure the app user
RUN groupadd -g $GID app \
  && useradd --create-home --no-log-init -u $UID -g $GID app \
  && chown app:app -R $HOME

# install production dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  cron \
  msmtp \
  msmtp-mta \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/* \
  && chmod u+s /usr/sbin/cron


### builder ###
FROM base AS builder

ARG PROCESSORS="8"
ENV MAKE="make --jobs ${PROCESSORS}"

# install development dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*


### bundle ###
FROM builder AS bundle

WORKDIR "/tmp"

# install production ruby gems
COPY lib lib
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment "true" \
  && bundle config set without "development test" \
  && bundle install 


### production ###
FROM base AS production

ARG GIT_COMMIT

ENV GIT_COMMIT=$GIT_COMMIT

# copy the application files
COPY --chown=app:app . $HOME
COPY --from=bundle /usr/local/bundle /usr/local/bundle
COPY --from=bundle --chown=app:app /tmp/vendor/bundle "${HOME}/vendor/bundle"

# start the app
USER app
ENTRYPOINT [ "script/_prod_entrypoint" ]
CMD ["bin/peoplesoft_course_class_data"]

### development ###
FROM builder AS development

# copy the application files
COPY --chown=app:app . $HOME

# install development ruby gems
USER app
RUN bundle install

# start the app
CMD ["/bin/bash"]
