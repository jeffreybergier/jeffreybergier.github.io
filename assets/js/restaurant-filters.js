/* Static cards remain readable when JavaScript is unavailable. */
(function () {
  'use strict';
  var root = document.getElementById('restaurant-browser');
  if (!root || !window.URL || !window.history.pushState) return;

  var form = root.querySelector('form');
  var cards = Array.from(root.querySelectorAll('[data-restaurant]'));
  var labels = { all: 'すべて', love: 'おすすめ', not_been: '行きたい', have_been: 'もう行った' };
  var sortLabels = { rating: '食べログ評価順', dateAdded: '追加日が新しい順' };
  var state;
  var renderedSort;
  // Sort across the whole selection, not separately inside geographic groups.
  // Move the existing cards; the grouped HTML remains the no-JavaScript fallback.
  var list = document.createElement('ul');
  list.className = 'restaurant-list restaurant-list--cards';
  cards.forEach(function (card) { list.appendChild(card); });
  var results = root.querySelector('.restaurant-results');
  results.textContent = '';
  results.appendChild(list);

  function unique(values) {
    return Array.from(new Set(values)).sort(function (a, b) {
      return a.localeCompare(b, 'ja');
    });
  }

  var regions = unique(cards.map(function (card) { return card.dataset.region; }));
  // Keep Tokyo easy to find without maintaining a separate region list.
  regions.sort(function (a, b) {
    return (b === '東京都' ? 1 : 0) - (a === '東京都' ? 1 : 0);
  });

  function localities(region) {
    return unique(cards.filter(function (card) {
      return card.dataset.region === region;
    }).map(function (card) { return card.dataset.locality; }));
  }

  function options(name, values, selected) {
    var container = form.querySelector('[data-filter="' + name + '"] .restaurant-filter-options');
    container.textContent = '';
    var multiple = name === 'locality';
    if (multiple) {
      var reset = document.createElement('button');
      reset.type = 'button';
      reset.dataset.clearLocality = '';
      reset.textContent = 'すべて';
      reset.setAttribute('aria-pressed', selected.length === 0);
      container.appendChild(reset);
    }
    (multiple ? values : [''].concat(values)).forEach(function (value) {
      var label = document.createElement('label');
      var input = document.createElement('input');
      input.type = multiple ? 'checkbox' : 'radio';
      input.name = name;
      input.value = value;
      input.checked = multiple ? selected.indexOf(value) !== -1 : value === selected;
      var text = document.createElement('span');
      text.textContent = value || 'すべて';
      label.appendChild(input);
      label.appendChild(text);
      container.appendChild(label);
    });
  }

  function readState() {
    var params = new URL(window.location.href).searchParams;
    var status = params.get('status');
    var sort = params.get('sort');
    if (!Object.prototype.hasOwnProperty.call(sortLabels, sort)) sort = 'rating';
    var region = params.get('region') || '';
    if (!Object.prototype.hasOwnProperty.call(labels, status)) status = 'love';
    if (regions.indexOf(region) === -1) region = '';
    // Repeated parameters support multiple selections and older single-value URLs.
    // Filtering the known options also removes duplicates and invalid localities.
    var requestedLocalities = params.getAll('locality');
    var locality = region ? localities(region).filter(function (value) {
      return requestedLocalities.indexOf(value) !== -1;
    }) : [];
    return { status: status, region: region, locality: locality, sort: sort };
  }

  function syncControls() {
    Array.from(form.querySelectorAll('input[name="status"], input[name="sort"]')).forEach(function (input) {
      input.checked = input.value === state[input.name];
    });
    options('region', regions, state.region);
    options('locality', localities(state.region), state.locality);
    form.querySelector('[data-filter="locality"]').hidden = !state.region;
  }

  function syncLocalityControls() {
    Array.from(form.querySelectorAll('input[name="locality"]')).forEach(function (input) {
      input.checked = state.locality.indexOf(input.value) !== -1;
    });
    form.querySelector('[data-clear-locality]').setAttribute('aria-pressed', state.locality.length === 0);
  }

  function render() {
    if (renderedSort !== state.sort) {
      var sorted = cards.slice().sort(function (a, b) {
        // ISO dates sort lexically, without timezone conversion. Missing values
        // sort last; same-day imports use rating, then original order, as ties.
        var dateOrder = state.sort === 'dateAdded' ?
          (b.dataset.dateAdded || '').localeCompare(a.dataset.dateAdded || '') : 0;
        return dateOrder || (Number(b.dataset.rating) || 0) - (Number(a.dataset.rating) || 0) ||
          cards.indexOf(a) - cards.indexOf(b);
      });
      var fragment = document.createDocumentFragment();
      sorted.forEach(function (card) { fragment.appendChild(card); });
      list.appendChild(fragment);
      renderedSort = state.sort;
    }
    var count = 0;
    cards.forEach(function (card) {
      var match = (state.status === 'all' || card.dataset.status === state.status) &&
        (!state.region || card.dataset.region === state.region) &&
        (state.locality.length === 0 || state.locality.indexOf(card.dataset.locality) !== -1);
      card.hidden = !match;
      if (match) {
        count += 1;
        var image = card.querySelector('img[data-src]');
        if (image) {
          image.src = image.dataset.src;
          image.removeAttribute('data-src');
          image.hidden = false;
        }
      }
    });
    form.querySelector('[role="status"]').textContent =
      [labels[state.status], state.region || 'すべての地域', state.locality.join('、'), sortLabels[state.sort]]
        .filter(Boolean).join(' · ') + ' — ' + count + '件';
    form.querySelector('.restaurant-filter-empty').hidden = count !== 0;
  }

  function saveState() {
    var url = new URL(window.location.href);
    ['status', 'region', 'sort'].forEach(function (key) {
      if (state[key]) url.searchParams.set(key, state[key]);
      else url.searchParams.delete(key);
    });
    url.searchParams.delete('locality');
    state.locality.forEach(function (value) { url.searchParams.append('locality', value); });
    window.history.pushState(null, '', url);
  }

  form.addEventListener('submit', function (event) { event.preventDefault(); });
  form.addEventListener('change', function (event) {
    var input = event.target;
    if (['status', 'region', 'locality', 'sort'].indexOf(input.name) === -1) return;
    if (input.name === 'locality') {
      state.locality = Array.from(form.querySelectorAll('input[name="locality"]:checked'))
        .map(function (selected) { return selected.value; });
      syncLocalityControls();
    } else {
      state[input.name] = input.value;
    }
    if (input.name === 'region') {
      state.locality = [];
      options('locality', localities(state.region), state.locality);
      form.querySelector('[data-filter="locality"]').hidden = !state.region;
    }
    // Do not rebuild the active control: preserve keyboard focus.
    render();
    saveState();
  });
  // The municipality reset is rebuilt when the prefecture changes.
  form.addEventListener('click', function (event) {
    if (!event.target.closest('[data-clear-locality]') || state.locality.length === 0) return;
    state.locality = [];
    syncLocalityControls();
    render();
    saveState();
  });
  form.querySelector('[data-clear-region]').addEventListener('click', function () {
    state.region = '';
    state.locality = [];
    syncControls();
    render();
    saveState();
    form.querySelector('input[name="region"]').focus();
  });
  window.addEventListener('popstate', function () {
    state = readState();
    syncControls();
    render();
  });

  state = readState();
  syncControls();
  render();
  form.hidden = false;
}());
