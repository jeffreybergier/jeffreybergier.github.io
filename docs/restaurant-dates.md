# Restaurant added-date provenance

`source/_data/restaurants.yml` owns `dateAdded`, a quoted `YYYY-MM-DD` string.
It means the date the restaurant entry was added to the blog's maintained list,
not a visit date, opening date, or metadata-fetch date. New entries should record
the day they are added. Status edits and metadata refreshes must not change it.

## Initial backfill

The 201 active entries were reconstructed using the commits on `main` touching
`source/unlisted/restaurants.md` and `source/_data/restaurants.yml`. Dates use the
commit author's calendar date in the recorded timezone (these commits use
`+09:00`), rather than the machine's current timezone.

| dateAdded | Entries | Evidence |
| --- | ---: | --- |
| `2026-06-21` | 174 | Apple Notes import `2c04e30`, YAML conversion `c013c28`, and equivalent entries resolved to Tabelog URLs in `2303b6e` |
| `2026-07-05` | 8 | New entries or explicit branch replacements in `27ebaef` |
| `2026-07-31` | 5 | Additions in `cd2e2e5` |
| `2026-11-01` | 14 | Additions in `39b967c` |

These counts describe the initial backfill, not a constraint on future entries.
The original Apple Notes save dates are unavailable; the bulk import date is
therefore the earliest supported blog date.

## Matching rules

1. Follow the first appearance of each canonical restaurant URL through the
   historical source YAML. Ignore later status/tag changes, removals elsewhere,
   and metadata refreshes. Strip Tabelog subpage suffixes such as `dtlphotolst`
   and `dtlrvwlst` when identifying the same restaurant.
2. The July 2 commit `2303b6e` converted the imported entries to canonical
   Tabelog URLs. Do **not** treat it as a new batch of restaurants. Match its
   entries back to the June YAML using original URLs retained in `urls`, names,
   and the original location/tag context. The surviving entries from this
   conversion inherit `2026-06-21`.
3. Some original entries were names, food notes, or chain references rather
   than specific Tabelog links. Their initial resolution inherits the saved
   entry's import date; this does not prove that the exact branch was recorded
   in Apple Notes. The less obvious matches are listed below.
4. The July 5 edit explicitly selected different branches or added restaurants.
   Those eight canonical URLs receive July 5, not the older chain's import date.
   For example, Komeda's Hakodate branch replaced its earlier Tokyo URL, and
   Pronto's Ginza branch replaced the Shinanomachi branch.
5. The five July 31 and fourteen November 1 URLs are additions in their diffs.
   Use those commit dates. Never infer added dates from `cached_at`.

### Name-only / changed-link matches in the July 2 migration

The original labels below are in `c013c28:source/_data/restaurants.yml`;
the corresponding canonical URLs and context are in `2303b6e`.

| Original saved entry | Current Tabelog restaurant ID |
| --- | --- |
| 銀座 鰤門 Ginza Seamon (`seamon.jp`) | `13004881` |
| 天ぷらつな八 (chain list) | `13031392` |
| ドトール (coffee chain list) | `13060188` |
| 上島 (coffee chain list) | `13154441` |
| 堂島ロール (日本橋三越) | `13058319` |
| おはぎ (日本橋三越) | `13145027` |
| 絵太郎・苺大福 (日本橋) | `13006473` |
| 苺大福 (新宿伊勢丹) | `13006772` |
| 千疋屋、マンプリ (小田急) | `13281004` |
| ＪＲステーションカフェ (東京駅) | `13320088` |
| サラベス (東京駅) | `13189541` |
| エクセルシオールカフェ (東京駅) | `13050213` |
| レーメンセット (東京ドームシティー > 和牛一頭焼肉 牛兵衛 草庵) | `13156119` |

To audit the evidence without relying on line blame after the migration:

```sh
git log --reverse --format='%h %aI %s' -- source/_data/restaurants.yml source/unlisted/restaurants.md
git show c013c28:source/_data/restaurants.yml
git show 2303b6e -- source/_data/restaurants.yml
git show 27ebaef -- source/_data/restaurants.yml
git show cd2e2e5 -- source/_data/restaurants.yml
git show 39b967c -- source/_data/restaurants.yml
```
