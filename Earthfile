VERSION 0.6

# This allows one to change the running Ruby version with:
#
# `earthly --allow-privileged +test --EARTHLY_RUBY_VERSION=3`
ARG EARTHLY_RUBY_VERSION=2.2

# This allows one to change the running Rails version with:
#
# `earthly --allow-privileged +test --EARTHLY_RAILS_VERSION=7`
ARG EARTHLY_RAILS_VERSION=4.2.11.3

# This allows one to change the running Rails version with:
#
# `earthly --allow-privileged +test --EARTHLY_DEVISE_VERSION=4.8.1`
ARG EARTHLY_DEVISE_VERSION=3.4.0

FROM ruby:$EARTHLY_RUBY_VERSION
WORKDIR /gem

deps:
    RUN apt update \
        && apt install --yes \
                       --no-install-recommends \
                       build-essential \
                       git

    COPY Gemfile /gem/Gemfile
    COPY *.gemspec /gem

    RUN bundle install --jobs $(nproc)

    RUN cat /gem/Gemfile.lock

    SAVE ARTIFACT /usr/local/bundle bundler
    SAVE ARTIFACT /gem/Gemfile Gemfile
    SAVE ARTIFACT /gem/Gemfile.lock Gemfile.lock

dev:
    RUN apt update \
        && apt install --yes \
                       --no-install-recommends \
                       git

    COPY +deps/bundler /usr/local/bundle
    COPY +deps/Gemfile /gem/Gemfile
    COPY +deps/Gemfile.lock /gem/Gemfile.lock

    COPY *.gemspec /gem
    COPY Rakefile /gem

    COPY app/ /gem/app/
    COPY config/ /gem/config/
    COPY lib/ /gem/lib/
    COPY test/ /gem/test/

    ENTRYPOINT ["bundle", "exec"]
    CMD ["rake"]

    SAVE IMAGE pharmony/devise_google_authenticator:latest

#
# This target runs the test suite.
#
# Use the following command in order to run the tests suite:
# earthly --allow-privileged +test
test:
    FROM earthly/dind:alpine

    COPY docker-compose-earthly.yml ./

    WITH DOCKER --load pharmony/devise_google_authenticator:latest=+dev
        RUN docker-compose -f docker-compose-earthly.yml run --rm gem
    END

#
# This target is used to publish this gem to rubygems.org.
#
# Prerequiries
# You should have login against Rubygems.org so that it has created
# the `~/.gem` folder and stored your API key.
#
# Then use the following command:
# earthly +gem --GEM_CREDENTIALS="$(cat ~/.gem/credentials)" --RUBYGEMS_OTP=123456
gem:
    FROM +dev

    ARG GEM_CREDENTIALS
    ARG RUBYGEMS_OTP

    COPY .git/ /gem/
    COPY CHANGELOG.md /gem/
    COPY LICENSE /gem/
    COPY README.md /gem/

    RUN gem build devise_google_authenticator.gemspec \
        && mkdir ~/.gem \
        && echo "$GEM_CREDENTIALS" > ~/.gem/credentials \
        && cat ~/.gem/credentials \
        && chmod 600 ~/.gem/credentials \
        && gem push --otp $RUBYGEMS_OTP devise_google_authenticator-*.gem

    SAVE ARTIFACT devise_google_authenticator-*.gem AS LOCAL ./devise_google_authenticator.gem
