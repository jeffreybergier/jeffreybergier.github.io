// Run against the preview server with Playwright available on NODE_PATH:
// node scripts/test_restaurant_filters.cjs [http://localhost:8081]
const assert = require('node:assert/strict');
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
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
    assert.equal(await page.locator('#markdown-toc').count(), 0);
    assert.equal(await visible.count(), await page.locator('[data-restaurant][data-status="love"]').count());
    assert.equal(await page.locator('[data-status="not_been"] img[src]').count(), 0, 'Unselected images are deferred');
    assert(await visible.locator('img[src]').count() > 0);
    const urls = await page.locator('[data-restaurant] a').evaluateAll(nodes => nodes.map(n => n.href));
    assert.equal(new Set(urls).size, urls.length, 'Each card rendered once');

    const choose = (name, value) => page.locator('input[name="' + name + '"]').evaluateAll((nodes, value) => {
      nodes.find(node => node.value === value).click();
    }, value);
    await choose('status', 'not_been');
    await choose('region', '東京都');
    await choose('locality', '中央区');
    assert(await visible.count() > 0);
    assert(await visible.evaluateAll(nodes => nodes.every(n => n.dataset.status === 'not_been' && n.dataset.region === '東京都' && n.dataset.locality === '中央区')));
    assert(await page.locator('[data-restaurant-group]:visible').evaluateAll(nodes => nodes.every(n => n.querySelector('[data-restaurant]:not([hidden])'))));
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

    await page.goto(url + '?status=invalid&region=invalid&locality=invalid');
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'love');
    assert.equal(await page.locator('input[name="region"]:checked').inputValue(), '');
    await page.setViewportSize({ width: 375, height: 812 });
    assert(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth));
    await page.locator('input[name="status"][value="love"]').focus();
    await page.keyboard.press('ArrowRight');
    assert.equal(await page.locator('input[name="status"]:checked').inputValue(), 'not_been');
    assert.equal(await page.locator(':focus').inputValue(), 'not_been');
    assert.deepEqual(errors, []);

    const noJS = await browser.newContext({ javaScriptEnabled: false });
    const fallback = await noJS.newPage();
    await fallback.route('**/*', route => route.request().url().startsWith(base) ? route.continue() : route.abort());
    await fallback.goto(url);
    assert.equal(await fallback.locator('[data-restaurant]:visible').count(), total);
    assert(await fallback.locator('.restaurant-filters').isHidden());
    assert(await fallback.locator('noscript img').count() > 0);
    await noJS.close();
    console.log('PASS: unique cards, defaults, filters, URL/reload, history, reset, empty state, invalid parameters, mobile width, keyboard, no-JS fallback');
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
