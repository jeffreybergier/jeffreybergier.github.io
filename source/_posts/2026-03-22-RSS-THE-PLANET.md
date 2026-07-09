---
layout: post
title: "RSS-THE-PLANET"
titleAccessoryStyle: wide
titleAccessory: "[![RSS-THE-PLANET title artwork](/assets/images/unenshittification/rss-the-planet/rss-the-planet-thumb.png)](/assets/images/unenshittification/rss-the-planet/rss-the-planet-full.png){: .reflect .below-xl .round-sm }"
excerpt: |
  Make your favorite doomscrolling apps work on any device by converting their
  simple JSON-based API into an old-fashioned RSS feed
categories: [Unenshittification]
tags: [Apple, Retro-Tech, Cloudflare, Serverless, iOS, Mac-OS-X]
---

## The Primary Feature: Doomscrolling

The dark secret of the vast majority of mobile apps we use, on
[iOS](https://www.apple.com/os/ios/) and
[Android](https://www.android.com/), is that they are basically doomscrolling
apps. Now that does not mean that they are serving you malicious content
necessarily. But they all have the same basic UX and use the same basic
implementation details. Whether the app is:

1. [Instagram](https://www.instagram.com/)
1. [Twitter / X](https://x.com/)
1. [Tinder](https://tinder.com/)
1. [New York Times](https://www.nytimes.com/)
1. [TikTok](https://www.tiktok.com/)
1. [YouTube](https://www.youtube.com/)
1. Etc

These apps all use the same basic technologies and features which are all really
simple in principle.

1. Fetch a list of content via [JSON](https://www.rfc-editor.org/rfc/rfc8259)
1. Save or cache that data in an [SQLite](https://www.sqlite.org/) database
1. Convert that JSON into a model that is useful for the view (ViewModel)
1. Display the list of ViewModels as a list in the UI
   ([UITableView](https://developer.apple.com/documentation/uikit/uitableview))
1. Asynchronously download related assets such as images and video

It is important to point out that all of these capabilities have been built into
iOS since iOS 5. This is super simple and obvious behavior that all mobile apps
share.

## Really Simple Syndication

You may not know this, but there is a really old technology that enables all
of this functionality that is used by almost every website AND almost every
podcast on the internet called [RSS](https://www.rssboard.org/rss-specification).
RSS uses [XML](https://www.w3.org/XML/) instead of JSON, but it enables the same
basic functionality using a category of apps called RSS readers. Common examples
are:

1. [NetNewsWire](https://netnewswire.com/)
1. [Vienna](https://www.vienna-rss.com/)
1. [Reeder](https://reederapp.com/)

## RSS-THE-PLANET

RSS-THE-PLANET is a very simple
[Cloudflare Worker](https://developers.cloudflare.com/workers/) application that
can encrypt and store your credentials for your doomscrolling apps and then
fetch their JSON API and convert it into normal RSS. Combine this with an RSS
reader and now you can enjoy your favorite doomscrolling content on a retro
device. For me, that retro device is an
[iPhone 5](https://support.apple.com/en-us/112016) running Reeder on iOS 6.

In fact, this improves the experience because these RSS reader apps often
support offline viewing. So yeah, now I have easy access to all of my
doomscrolling content even when totally offline:

1. [Mastodon](https://joinmastodon.org/)
1. [News](https://www.apple.com/apple-news/)
1. [YouTube](https://www.youtube.com/)
1. [Podcasts](https://www.apple.com/apple-podcasts/)

RSS-THE-PLANET also includes basic features to proxy websites and images through
Cloudflare to downgrade their TLS restrictions to 1.0 or none at all
for older devices that do not support 
[TLS 1.2](https://www.rfc-editor.org/rfc/rfc5246) natively.

## Caveats

RSS-THE-PLANET is not a hosted service. But the code is MIT licensed and so you
can run it yourself for free in your Cloudflare account.

[https://github.com/jeffreybergier/RSS-THE-PLANET](https://github.com/jeffreybergier/RSS-THE-PLANET)

Note that this approach is inherently insecure. While your credentials are
encrypted in Cloudflare, the generated RSS URLs allow unauthenticated access to 
your feeds. So please use with caution and keep your RSS feed links secret.
