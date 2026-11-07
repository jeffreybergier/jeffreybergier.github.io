// Run against the preview server with Playwright available on NODE_PATH:
// node scripts/test_restaurant_filters.cjs [http://localhost:8081]
const assert = require('node:assert/strict');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ executablePath: process.env.CHROMIUM_PATH || undefined });
  try {
    const base = process.argv[2] || 'http://localhost:8081';
    const url = base + '/unlisted/restaurants.html';
    const page = await browser.newPage();
    const errors = [];
    page.on('pageerror', error => errors.push(error.message));
    // Keep this an offline UI test; restaurant images are third-party resources.
    await page.route('**/*', route => {
      if (!route.request().url().startsWith(base)) return route.abort();
      return route.continue();
    });
    await page.goto(url);
    const visible = page.locator('[data-restaurant]:visible');
    const total = await page.locator('[data-restaurant]').count();
    assert(total > 0);
    assert(await page.locator('[data-restaurant]').evaluateAll(nodes => nodes.every(node => {
      const title = node.querySelector('.restaurant-card-title, .restaurant-name');
      return title && !title.textContent.trim().startsWith('https://') &&
        node.dataset.region !== '地域不明' && node.dataset.locality !== '市区町村不明';
    })), 'All cards must have names and geographic metadata, not URL-only fallbacks');
    assert(await page.locator('[data-restaurant]').evaluateAll(nodes => nodes.every(node => {
      const date = node.querySelector('time');
      return /^\d{4}-\d{2}-\d{2}$/.test(node.dataset.dateAdded) &&
        date && date.dateTime === node.dataset.dateAdded && date.textContent === node.dataset.dateAdded;
    })), 'All cards expose and display their added date');
    assert.equal(await page.locator('#markdown-toc').count(), 0);
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'rating');
    const assertSorted = async mode => {
      const values = await visible.evaluateAll(nodes => nodes.map(n => ({
        date: n.dataset.dateAdded, rating: Number(n.dataset.rating) || 0
      })));
      assert(values.length > 1, 'Sorting must be tested on multiple cards');
      for (let i = 1; i < values.length; i++) {
        const a = values[i - 1], b = values[i];
        if (mode === 'dateAdded' && a.date !== b.date) assert(a.date > b.date, 'Newest first across all groups');
        else assert(a.rating >= b.rating, 'Rating descending (also breaks same-day ties)');
      }
    };
    await assertSorted('rating');
    assert.equal(await visible.count(), await page.locator('[data-restaurant][data-status="love"]').count());
    assert.equal(await page.locator('[data-status="not_been"] img[src]').count(), 0, 'Unselected images are deferred');
    assert(await visible.locator('img[src]').count() > 0);
    const urls = await page.locator('[data-restaurant] a').evaluateAll(nodes => nodes.map(n => n.href));
    assert.equal(new Set(urls).size, urls.length, 'Each card rendered once');

    const choose = (name, value) => page.locator('input[name="' + name + '"]').evaluateAll((nodes, value) => {
      nodes.find(node => node.value === value).click();
    }, value);
    assert.equal(await page.locator('input[name="status"]').first().inputValue(), 'all');
    await choose('status', 'all');
    assert.equal(await visible.count(), total);
    await assertSorted('rating');
    const ratingOrder = await visible.evaluateAll(nodes => nodes.map(n => n.querySelector('a').href));
    await choose('sort', 'dateAdded');
    assert.equal(new URL(page.url()).searchParams.get('sort'), 'dateAdded');
    await assertSorted('dateAdded');
    const newestDate = await page.locator('[data-restaurant]').evaluateAll(nodes =>
      nodes.map(n => n.dataset.dateAdded).sort().pop());
    assert.equal(await visible.first().getAttribute('data-date-added'), newestDate);
    await page.reload();
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'dateAdded');
    await assertSorted('dateAdded');
    await choose('sort', 'rating');
    assert.deepEqual(await visible.evaluateAll(nodes => nodes.map(n => n.querySelector('a').href)), ratingOrder);
    await page.goBack();
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'dateAdded');
    await assertSorted('dateAdded');
    await page.goForward();
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'rating');
    await assertSorted('rating');
    await choose('sort', 'dateAdded');
    await page.reload();
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'all');
    assert.equal(await visible.count(), total);
    await choose('region', '東京都');
    assert.equal(await visible.count(), await page.locator('[data-restaurant][data-region="東京都"]').count());
    await choose('status', 'not_been');
    await choose('region', '東京都');
    await choose('locality', '中央区');
    assert(await visible.count() > 0);
    assert(await visible.evaluateAll(nodes => nodes.every(n => n.dataset.status === 'not_been' && n.dataset.region === '東京都' && n.dataset.locality === '中央区')));
    await assertSorted('dateAdded');
    assert.equal(await page.locator('.restaurant-results > .restaurant-list').count(), 1);
    assert.equal(await page.locator('[data-restaurant]').count(), total, 'Sorting moves cards, never duplicates them');
    const filteredURL = page.url();
    await page.reload();
    assert.equal(page.url(), filteredURL);
    assert.equal(await page.locator('input[name="locality"]:checked').inputValue(), '中央区');
    await choose('status', 'have_been');
    await page.goBack();
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'not_been');
    await page.goForward();
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'have_been');

    await choose('region', '山形県');
    assert.equal(await page.locator('input[name="locality"]:checked').inputValue(), '');
    assert.equal(await visible.count(), 0);
    assert(await page.locator('.restaurant-filter-empty').isVisible());
    await page.locator('[data-clear-region]').click();
    assert(await visible.count() > 0);
    assert.equal(await page.locator('input[name="region"]:checked').inputValue(), '');
    assert(await page.locator('[data-filter="locality"]').isHidden());
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'dateAdded');
    await assertSorted('dateAdded');

    await page.goto(url + '?status=invalid&region=invalid&locality=invalid&sort=invalid');
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'rating');
    await assertSorted('rating');
    await choose('sort', 'dateAdded');
    assert.equal(await page.locator('[data-status="not_been"] img[src]').count(), 0, 'Sorting does not load unselected images');
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'love');
    assert.equal(await page.locator('input[name="region"]:checked').inputValue(), '');
    await page.setViewportSize({ width: 375, height: 812 });
    assert(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth));
    await page.locator('input[name="status"][value="love"]').focus();
    await page.keyboard.press('ArrowRight');
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'not_been');
    assert.equal(await page.locator(':focus').inputValue(), 'not_been');
    await page.locator('input[name="sort"][value="dateAdded"]').focus();
    await page.keyboard.press('ArrowLeft');
    assert.equal(await page.locator('input[name="sort"]:checked').inputValue(), 'rating');
    assert.equal(await page.locator(':focus').inputValue(), 'rating');
    await assertSorted('rating');
    assert.deepEqual(errors, []);

    const noJS = await browser.newContext({ javaScriptEnabled: false });
    const fallback = await noJS.newPage();
    await fallback.route('**/*', route => route.request().url().startsWith(base) ? route.continue() : route.abort());
    await fallback.goto(url + '?sort=dateAdded');
    assert.equal(await fallback.locator('[data-restaurant]:visible').count(), total);
    assert(await fallback.locator('.restaurant-filters').isHidden());
    assert(await fallback.locator('noscript img').count() > 0);
    assert(await fallback.locator('[data-restaurant-group]:visible').count() > 0);
    assert(await fallback.locator('.restaurant-list').evaluateAll(lists => lists.every(list => {
      const ratings = Array.from(list.children).map(n => Number(n.dataset.rating) || 0);
      return ratings.every((value, index) => index === 0 || ratings[index - 1] >= value);
    })), 'No-JS view retains grouped rating order');
    await noJS.close();
    console.log('PASS: unique dated cards, rating/date sorting, defaults, filters, URL/reload, history, reset, empty state, invalid parameters, deferred images, mobile width, keyboard, no-JS fallback');
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
