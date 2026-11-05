# jeffreybergier.github.io

Jekyll source lives in `source/`.

### Open an Altivec Shell

`docker compose run --rm altivec-intelligence`

### Serve Jekyll

`podman compose up serve`

Open `http://localhost:8080`. Docker users can substitute `docker` for `podman`
in these commands.

Preview startup uses the checked-in restaurant snapshot without contacting
Tabelog. It checks installed gems first, installing only if dependencies are
missing. After an initial successful online launch, the same command works
without Wi-Fi, provided the container image and gem cache are still present.
`podman compose down` preserves the cache; `down --volumes` does not.

If restaurant names or locations are missing, startup fails promptly rather
than attempting network requests. Refresh the snapshot while online (below).
Remote restaurant images and other externally hosted browser resources still
require connectivity; this makes the local server start offline, not every
external resource available offline.

### Refresh Restaurant Cards

While online, use the cached toolchain image:

```sh
podman compose run --rm --no-deps serve -lc \
  'ruby ../scripts/cache_restaurant_cards.rb --refresh'
```

Or, with Ruby installed locally:
`ruby scripts/cache_restaurant_cards.rb --refresh`

This updates `source/_data/restaurant_cards.yml`, a checked-in metadata snapshot
used by Jekyll. Commit the snapshot when adding restaurants or refreshing their
metadata. Deployment uses `ruby scripts/cache_restaurant_cards.rb --offline`:
it makes no Tabelog requests and fails before publishing if required names or
locations are missing. Editorial statuses and tags always come from
`source/_data/restaurants.yml`.

Run the offline snapshot regression tests with:

```sh
ruby scripts/test_restaurant_snapshot.rb
```

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

Bundler installs gems under `/cache/bundle/install` in the Compose-managed
`cache` volume. Keeping that cache off the macOS bind mount avoids git hardlink
failures under Colima.

If you previously hit a `fatal: hardlink different from source` error, remove
the old host-mounted Bundler cache once:

`rm -rf ~/.altivec/.bundle/jeffreybergier.github.io`
