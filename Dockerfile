# Use Debian as a parent image
FROM debian:latest

# Update the package index and install necessary packages
RUN apt-get update && apt-get install -y \
    ruby \
    ruby-bundler \
    ruby-dev \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /source

# Display Ruby version and bundler version
RUN ruby --version && bundle --version && gem install bundler jekyll

# Command to run when the container starts
CMD ["irb"]
