FROM ruby:3.4.1

# Install system dependencies in a single layer
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        nodejs \
        postgresql-client \
        build-essential \
        libpq-dev \
        vim && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /myproject

# Install Ruby dependencies first (better layer caching)
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle install

# Copy application code last
COPY . .

# Create non-root user with proper HOME directory
RUN groupadd -r myapp && useradd -r -g myapp -m -d /home/myapp myapp
RUN chown -R myapp:myapp /myproject

# Set HOME environment variable
ENV HOME=/home/myapp

USER myapp

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]