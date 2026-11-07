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
locations are missing. Editorial statuses, tags, and `dateAdded` always come
from `source/_data/restaurants.yml`. Every restaurant requires a quoted ISO date,
for example `dateAdded: "2026-11-01"`. Set it when adding an entry and preserve
it when changing status, tags, or refreshing metadata. The snapshot validator
rejects missing or invalid dates. `cached_at` remains the metadata-fetch time,
not the added date.

Existing dates were backfilled from Git history, including the original Apple
Notes import and later URL migrations. See [date provenance](docs/restaurant-dates.md)
for the reconstruction rules and date breakdown.

Run the offline snapshot regression tests with:

```sh
ruby scripts/test_restaurant_snapshot.rb
```

### Restaurant Filters

The restaurant page is built as static HTML with one card per restaurant.
`source/assets/js/restaurant-filters.js` adds single-select status and prefecture
filters, plus multi-select municipality buttons. Click a municipality to toggle
it on/off; results match **any** selected municipality. **すべて** clears the
municipality selection, as does changing the prefecture. With none selected,
all municipalities in the current prefecture are shown. The buttons use native
checkboxes for keyboard/assistive-technology support (Tab to focus, Space to
toggle).

A sort toggle offers **Tabelog rating** (highest first, the default) or **date
added** (newest first). Sorting applies across all matching cards, not just within
geographic groups. Same-day additions use rating as a
tiebreaker; equal ratings retain the original static order. Each card displays
its added date, location, and visit status.

Selections are stored in the URL query parameters `status`, `region`, `locality`,
and `sort` (`rating` or `dateAdded`); region/locality values use the Japanese names
from the cached data. Multiple municipalities use repeated parameters, e.g.
`?region=東京都&locality=中央区&locality=千代田区`. Older single-municipality
links still work; duplicate or invalid locality values are ignored. Clearing
the municipality selection removes all `locality` parameters. Selections survive
reloads and browser Back/Forward. Missing/invalid sort parameters fall back to
rating. Without JavaScript, all cards remain readable in their original status/location
groups, sorted by rating within each group. Images for unselected cards are
deferred until those cards are first selected.

With the preview server running, run the browser regression checks using
Playwright (installed outside the checkout):

```sh
npm install --prefix /tmp/jeffburg-filter-tests playwright
/tmp/jeffburg-filter-tests/node_modules/.bin/playwright install chromium
NODE_PATH=/tmp/jeffburg-filter-tests/node_modules \
  node scripts/test_restaurant_filters.cjs http://localhost:8081
```

Use the preview server's actual port (normally 8080). To use an installed browser
instead of downloading one, set `CHROMIUM_PATH=/usr/bin/chromium` when running
the test. Tests block external requests and cover sorting (including same-day
ties), multi-selection/toggling/reset, filtering, URL/reload/history, keyboard
interaction, narrow-screen layout, deferred images, and the no-JavaScript fallback.

Bundler installs gems under `/cache/bundle/install` in the Compose-managed
`cache` volume. Keeping that cache off the macOS bind mount avoids git hardlink
failures under Colima.

If you previously hit a `fatal: hardlink different from source` error, remove
the old host-mounted Bundler cache once:

`rm -rf ~/.altivec/.bundle/jeffreybergier.github.io`
