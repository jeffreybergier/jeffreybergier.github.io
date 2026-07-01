# jeffreybergier.github.io

Jekyll source lives in `source/`.

### Open an Altivec Shell

`docker compose run --rm altivec-intelligence`

### Serve Jekyll

`docker compose up serve`

Open `http://localhost:8080`.

### Refresh Restaurant Cards

`ruby scripts/cache_restaurant_cards.rb --refresh`

This generates `source/_data/restaurant_cards.yml`, which is ignored by git and
used by Jekyll during the build.

Bundler installs gems into a Docker-managed volume named `bundle`. Keeping that
cache off the macOS bind mount avoids git hardlink failures under Colima.

If you previously hit a `fatal: hardlink different from source` error, remove
the old host-mounted Bundler cache once:

`rm -rf ~/.altivec/.bundle/jeffreybergier.github.io`
