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


### development ###
FROM builder AS development

# copy the application files
COPY --chown=app:app . $HOME

# install development ruby gems
USER app
RUN bundle install

# start the app
CMD ["/bin/bash"]
