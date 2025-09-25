# Use Debian as a parent image
FROM debian:latest

# Update the package index and install necessary packages
RUN apt-get update && apt-get install -y \ 
    ruby \
    ruby-bundler \
    ruby-dev \
    nano \
    build-essential \ 
 && rm -rf /var/lib/apt/lists/* 

# Set the working directory to /app
WORKDIR /app

# Display Ruby version and bundler version
RUN gem install jekyll -v 4.4.1
RUN gem install minima -v 2.5.2
RUN gem install jekyll-feed -v 0.17.0
RUN gem install jekyll-seo-tag -v 2.8.0
RUN gem install rake -v 13.3.0
RUN gem install rouge -v 4.6.1
RUN gem install rexml -v 3.4.4
RUN gem install json -v 2.15.0
RUN gem install csv -v 3.3.5
RUN gem install bigdecimal -v 3.2.3
RUN gem install base64 -v 0.3.0

# Default command
CMD ["jekyll", "serve", "--host", "0.0.0.0", "--port", "4000"]