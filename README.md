# jeffreybergier.github.io

### Build Docker Container

`cd ~/Developer/My\ Github/jeffreybergier.github.io `
`docker build -t jekyll-container .`

### Confirm It Works

`docker run --rm jekyll-container jekyll --version`

### Create New Project (if needed)

`docker run --rm -it --volume="$PWD:/app" jekyll-container jekyll new /app/temp --skip-bundle`

Move the files from the temp folder into the root folder

### Serve

`docker run --rm -it -p 8080:4000 --volume="$PWD:/app" jekyll-container jekyll serve --host 0.0.0.0 --port 4000`

