---
layout: post
title: "RSS-THE-PLANET"
titleAccessoryStyle: wide
titleAccessory: "[![RSS-THE-PLANET title artwork](/assets/images/unenshittification/rss-the-planet/rss-the-planet-thumb.png)](/assets/images/unenshittification/rss-the-planet/rss-the-planet-full.png){: .reflect .below-xl .round-sm }"
excerpt: |
  Make your favorite doomscrolling apps work on any device by converting their 
  simple JSON-based API into an old fashioned RSS feed
categories: [Unenshittification]
tags: [Apple, Retro-Tech, Cloudflare, Serverless, iOS, Mac-OS-X]
---

## Outline

### The Doomscrolling Problem

- Open with the basic contradiction:
  - Mastodon, YouTube, and similar apps are mostly lists of posts, links, videos,
    comments, dates, authors, and thumbnails.
  - That information should be simple to move around.
  - Instead, it usually arrives wrapped in heavyweight apps, tracking, dark
    patterns, infinite scroll, autoplay, and device requirements that have
    nothing to do with the content itself.
- Tie this back to the larger unenshittification project:
  - I do not want every service to own the entire experience.
  - I want the data without the slot machine.
  - I want the same information to work on the devices I actually enjoy using.

### The Retro Device Test

- Explain the concrete goal:
  - I wanted Mastodon and YouTube to be usable from my iPhone 5 through
    Reeder.app.
  - The same idea should also work on other retro devices, old Macs, older RSS
    readers, and anything else that can still speak normal web standards.
- Make the point that RSS is the compatibility layer:
  - RSS is boring in exactly the right way.
  - Old devices understand it.
  - Modern devices understand it.
  - It does not require an app-store account, a modern browser engine, push
    notifications, background daemons, or a 300 MB client.

### What RSS-THE-PLANET Does

- Introduce the project:
  - RSS-THE-PLANET turns modern doomscrolling services back into plain RSS
    feeds.
  - The technical deep dive, setup instructions, and source code are on GitHub:
    <https://github.com/jeffreybergier/RSS-THE-PLANET>
- Describe the current useful cases without getting too deep:
  - Mastodon timelines, notifications, and profiles become RSS.
  - YouTube subscriptions and playlists become RSS.
  - Existing feeds can be proxied and cleaned up when old readers cannot handle
    them directly.
  - The broader pattern is: take the simple JSON/API version of a service and
    expose the part I care about as a feed.

### Why Not Just Use the Apps?

- Contrast the native app experience with the RSS experience:
  - Native apps are optimized for engagement.
  - RSS readers are optimized for reading and leaving.
  - Reeder on iOS 6 feels calmer, faster, and more intentional than opening a
    modern social app.
- Emphasize that this is not nostalgia for nostalgia's sake:
  - The iPhone 5 is perfectly capable of showing text, links, thumbnails, and
    video links.
  - The problem is not that the device is too weak.
  - The problem is that the modern app stack is too heavy and too hostile.

### The YouTube Example

- Use YouTube as the most obvious example:
  - I want to know when channels I subscribe to publish something.
  - I do not necessarily want the full YouTube homepage, recommendations,
    autoplay, Shorts, comments, notifications, and engagement machinery.
- Explain what the feed changes:
  - Videos become entries in a list.
  - I can scan them alongside everything else.
  - I can open only the videos I actually want.
  - Filtering Shorts restores some signal by removing the shortest, most
    disposable entries.

### The Mastodon Example

- Use Mastodon as the friendlier-but-still-doomscrolling example:
  - Mastodon is better aligned with the open web, but the timeline is still a
    timeline.
  - A timeline can still become compulsive if the interface invites endless
    checking.
- Explain what RSS changes:
  - Posts arrive in batches.
  - Read state belongs to the reader.
  - The experience becomes closer to email or blogs than a slot-machine feed.

### The Privacy and Security Tradeoff

- Be clear about the tradeoff:
  - A private timeline exposed as RSS is only as private as the final feed URL.
  - This is why the project is designed for self-hosting instead of one public
    instance everyone uses.
- Keep this section practical, not scary:
  - Use read-only tokens.
  - Use long private feed keys.
  - Treat generated feed URLs like passwords.
  - Revoke tokens if a URL leaks.
- Point readers to GitHub for the exact setup and security details.

### The Emotional Payoff

- Describe what it feels like when it works:
  - My iPhone 5 can read modern internet content through a quiet old RSS app.
  - My old devices feel less like museum pieces and more like computers again.
  - The services still exist, but they no longer dictate the entire shape of my
    attention.
- Connect this to the "bicycle for the mind" idea:
  - The useful part of the computer is not raw speed.
  - The useful part is agency.
  - RSS-THE-PLANET gives some of that agency back.

### What This Is Not

- Set expectations:
  - This is not a general-purpose replacement for every social app.
  - This is not a polished hosted service.
  - This is not the article where I explain every Cloudflare Worker, API, token,
    cache, and feed-generation detail.
- State the intended audience:
  - People who like old computers.
  - People who still like RSS.
  - People who want fewer apps and more control.
  - People willing to self-host small tools to make their digital life calmer.

### Closing Thought

- End with the core thesis:
  - A lot of the modern internet is still just lists of things.
  - If I can turn those lists back into feeds, I can choose the reader, the
    device, the pace, and the experience.
  - That is the whole point of RSS-THE-PLANET: take the planet-sized
    doomscrolling machine and shrink it back down into something my iPhone 5 can
    read.
