FROM ruby:3.3-slim AS base

EXPOSE 3000

ENV APP_USER=dvtools
ENV APP_UID=49001

# ------------------------------------------------------------
# Create the application user/group and installation directory

RUN groupadd --system --gid $APP_UID $APP_USER \
    && useradd --home-dir /opt/app --system --uid $APP_UID --gid $APP_USER $APP_USER

RUN mkdir -p /opt/app \
    && chown -R $APP_USER:$APP_USER /opt/app /usr/local/bundle


RUN apt-get update -qq

RUN apt-get install -y --no-install-recommends \
    curl \
    git \
    gpg \
    libpq-dev \ 
    libvips42 
    #bash-completion build-essential vim

# Install Node.js and Yarn from their own repositories

# Add Node.js package repository (version 16 LTS release) & install Node.js
# -- note that the Node.js setup script takes care of updating the package list
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y --no-install-recommends nodejs

# Add Yarn package repository, update package list, & install Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends yarn

# Remove packages we only needed as part of the Node.js / Yarn repository
# setup and installation -- note that the Node.js setup scripts installs
# a full version of Python, but at runtime we only need a minimal version
RUN apt-mark manual python3-minimal \
    && apt-get autoremove --purge -y \
      curl \
      python3

WORKDIR /opt/app

USER ${APP_USER}

ENV PATH="/opt/app/bin:$PATH"

ENTRYPOINT ["docker-entrypoint"]

CMD ["rails", "server", "-b", "0.0.0.0"]

FROM base AS development

USER root

# Install system packages needed to build gems with C extensions.
RUN apt-get install -y --no-install-recommends \
    g++ \
    make

# ------------------------------------------------------------
# Install Ruby gems

# Drop back to $APP_USER.
USER $APP_USER

# Base image ships with an older version of bundler
RUN gem install bundler --version 2.3.25

# Install gems. We don't enforce the validity of the Gemfile.lock until the
# final (production) stage.
COPY --chown=$APP_USER:$APP_USER Gemfile* .ruby-version ./
RUN bundle install

# ------------------------------------------------------------
# Install JS packages

# Install JS packages
# COPY --chown=$APP_USER:$APP_USER package.json yarn.lock ./
# RUN yarn install

# ------------------------------------------------------------
# Copy codebase

# Copy the rest of the codebase. We do this after installing packages so that
# changes unrelated to the packages don't invalidate the cache and force a slow
# re-install.
COPY --chown=$APP_USER:$APP_USER . .

# =============================================================================
# Target: production
#
# The production stage extends the base image with the application and gemset
# built in the development stage. It includes runtime dependencies but not
# heavyweight build dependencies.
FROM base AS production

# ------------------------------------------------------------
# Configure for production

# Run the production stage in production mode.
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

# ------------------------------------------------------------
# Copy code and installed gems

# Copy the built codebase from the dev stage
COPY --from=development --chown=$APP_USER /opt/app /opt/app
COPY --from=development --chown=$APP_USER /usr/local/bundle /usr/local/bundle

# Ensure the bundle is installed and the Gemfile.lock is synced.
RUN bundle config set frozen 'true'
RUN bundle install --local

# Ensure JS modules are installed and yarn.lock is synced
RUN yarn install --immutable

# ------------------------------------------------------------
# Precompile production assets

# Pre-compile assets so we don't have to do it after deployment.
# NOTE: dummy SECRET_KEY_BASE to prevent spurious initializer issues
#       -- see https://github.com/rails/rails/issues/32947
RUN SECRET_KEY_BASE=1 rails assets:precompile --trace

# ------------------------------------------------------------
# Preserve build arguments

# passed in by Jenkins
ARG BUILD_TIMESTAMP
ARG BUILD_URL
ARG DOCKER_TAG
ARG GIT_BRANCH
ARG GIT_COMMIT
ARG GIT_URL

# build arguments aren't persisted in the image, but ENV values are
ENV BUILD_TIMESTAMP="${BUILD_TIMESTAMP}"
ENV BUILD_URL="${BUILD_URL}"
ENV DOCKER_TAG="${DOCKER_TAG}"
ENV GIT_BRANCH="${GIT_BRANCH}"
ENV GIT_COMMIT="${GIT_COMMIT}"
ENV GIT_URL="${GIT_URL}"

### OLD DEFAULT RAILS 7 dockerfie
# # syntax = docker/dockerfile:1

# # Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
# ARG RUBY_VERSION=3.3.0
# FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# # Rails app lives here
# WORKDIR /rails

# # Set production environment
# ENV RAILS_ENV="production" \
#     BUNDLE_DEPLOYMENT="1" \
#     BUNDLE_PATH="/usr/local/bundle" \
#     BUNDLE_WITHOUT="development"


# # Throw-away build stage to reduce size of final image
# FROM base as build

# # Install packages needed to build gems
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y build-essential git libvips pkg-config

# # Install application gems
# COPY Gemfile Gemfile.lock ./
# RUN bundle install && \
#     rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
#     bundle exec bootsnap precompile --gemfile

# # Copy application code
# COPY . .

# # Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# # Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# # Final stage for app image
# FROM base

# # Install packages needed for deployment
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y curl libsqlite3-0 libvips && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # Copy built artifacts: gems, application
# COPY --from=build /usr/local/bundle /usr/local/bundle
# COPY --from=build /rails /rails

# # Run and own only the runtime files as a non-root user for security
# RUN useradd rails --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER rails:rails

# # Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# # Start the server by default, this can be overwritten at runtime
# EXPOSE 3000
# CMD ["./bin/rails", "server"]