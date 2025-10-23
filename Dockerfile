# syntax=docker/dockerfile:1

FROM ruby:3.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the code
COPY . .

# Set entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
