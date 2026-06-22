# jeffreybergier.github.io

Jekyll source lives in `source/`.

### Open an Altivec Shell

`docker compose run --rm altivec-intelligence`

### Serve Jekyll

`docker compose up serve`

Open `http://localhost:8080`.

Bundler installs gems into a Docker-managed volume named `bundle`. Keeping that
cache off the macOS bind mount avoids git hardlink failures under Colima.

If you previously hit a `fatal: hardlink different from source` error, remove
the old host-mounted Bundler cache once:

`rm -rf ~/.altivec/.bundle/jeffreybergier.github.io`
