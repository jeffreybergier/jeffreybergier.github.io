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

### Restaurant Filters

The restaurant page is built as static HTML with one card per restaurant.
`source/assets/js/restaurant-filters.js` adds single-select status, prefecture,
and municipality filters. Selections are stored in the URL query parameters
`status`, `region`, and `locality`; region/locality values use the Japanese names
from the cached data. Without JavaScript, all grouped cards remain readable.
Images for unselected cards are deferred until those cards are first selected.

With the preview server running, run the browser regression checks using
Playwright (installed outside the checkout):

```sh
npm install --prefix /tmp/jeffburg-filter-tests playwright
/tmp/jeffburg-filter-tests/node_modules/.bin/playwright install chromium
NODE_PATH=/tmp/jeffburg-filter-tests/node_modules \
  node scripts/test_restaurant_filters.cjs http://localhost:8081
```

Use the preview server's actual port (normally 8080). Tests block external
requests and cover filtering, history, keyboard interaction, narrow-screen
layout, deferred images, and the no-JavaScript fallback.

Bundler installs gems into a Docker-managed volume named `bundle`. Keeping that
cache off the macOS bind mount avoids git hardlink failures under Colima.

If you previously hit a `fatal: hardlink different from source` error, remove
the old host-mounted Bundler cache once:

`rm -rf ~/.altivec/.bundle/jeffreybergier.github.io`
