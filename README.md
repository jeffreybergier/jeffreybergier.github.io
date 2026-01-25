# jeffreybergier.github.io

Basic but wrong instructions are from https://dev.to/cuongnp/setting-up-a-local-development-environment-for-jekyll-with-docker-d8k

### Build New Docker Container

`cd ~/Developer/My\ Github/jeffreybergier.github.io `
`docker build -t ruby-container .`

### Launch Docker Compose

`docker-compose up -d`
`docker exec -it jekyll-environment bash`

### Set up new jekyll site

`jekyll new temp`

Then move everything from temp into the parent (jekyll) folder

### Serve Jekyll

`bundle install`
`bundle exec jekyll serve --host 0.0.0.0 --port 8080`

### Open In Your Browser

`http://localhost:8080`
