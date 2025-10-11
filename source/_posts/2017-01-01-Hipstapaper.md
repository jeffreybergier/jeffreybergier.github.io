---
layout: post-accessory
title: "Hipstapaper"
titleAccessory: "![Hipstapaper Screenshot](/assets/images/apps/hipstapaper/title.png){: .page-title .reflect .below-xl .round-sm }"
excerpt: "Hipstapaper was my very first cross-platform app that works on iPhone, iPad, and macOS"
categories: [Apps]
tags: [cocoa, cocoa-touch, swift, uikit, appkit]
accessory: |
  [![Hipstapaper Screenshot 1](/assets/images/apps/hipstapaper/01-thumb.png)](/assets/images/apps/hipstapaper/01-full.png)
  [![Hipstapaper Screenshot 2](/assets/images/apps/hipstapaper/02-thumb.png)](/assets/images/apps/hipstapaper/02-full.png)
  [![Hipstapaper Screenshot 3](/assets/images/apps/hipstapaper/03-thumb.png)](/assets/images/apps/hipstapaper/03-full.png)
  [![Hipstapaper Screenshot 4](/assets/images/apps/hipstapaper/04-thumb.png)](/assets/images/apps/hipstapaper/04-full.png)
---

## Overview

Hipstapaper is an app I built for myself to save links to web pages similar to 
Instapaper which was popular in the 2012's or so. But as Instapaper was losing
traction, I didn't want to lose the functionality

- Basic CRUD management of websites
- Tagging, Filtering, Sorting
- Bulk editing
- State restoration
- iPadOS and macOS Menus
- iPadOS and macOS "Scenes" for multiple window support
- Share extension for adding content
- iCloud Sync

### Download

I never release Hipstapaper on the AppStore but you can always use Hipstaper
on your iOS and macOS devices using the links below:

- [macOS Downloads](https://github.com/jeffreybergier/Hipstapaper/tree/main/Releases/macOS)
- [iOS TestFlight](https://testflight.apple.com/join/V1f2j5Jd)
- [Hipstapaper Source Code](https://github.com/jeffreybergier/Hipstapaper/)

### Table of Contents

* TOC
{:toc}

## Development

Hipstapaper was a learning exercise I wanted to learn how to make a
cross-platform application that worked on all of Apple's platforms, including
macOS. This was a big learning opportunity as I had never made an AppKit based
app before. The TL;DR is that I ended up liking AppKit even more than UIKit and
most of the toy apps I make now are either AppKit or SwiftUI.

### Phase 1 (2016-2018)

During this phase, there were no cross-platform UI frameworks from Apple and
there was no Database that had online syncing from Apple. Thus the technologies 
I chose were not ideal, but they were the only way to get the job done:

1. Cross-Platform: UIKit and AppKit UI implementations
  - Two UI implementations meant everything had to be implemented and updated
    twice. This was a big pain
1. Realm Database: Realm featured powerful sync capabilities that iCloud could
   not match
  - Realm was a great database, but it was not the platform standard "Core Data"
1. Realm Sync Server: Realm-powered server running in Digital Ocean
  - Running my own server meant that I would never be able to support users for
    free. So this kept the app limited to my own personal use.
    
### Phase 2 (2019-2021)

In WWDC 2019, Apple introduced Core Data syncing via CloudKit. While Apple
pitched this as their final solution to Core Data syncing, the actual
[session video](https://developer.apple.com/videos/play/wwdc2019/202) they
published was so quick, and so information dense that it was hard to follow.
As well, the feature has fundamental limitations, that I think have prevented
it from being very successful.

But with the introduction of Core Data syncing, I worked in Hipstapaper to 
swap out Realm with Core Data. This was no easy task as I had not wrapped
Realm in its own wrapper and Realm headers and tokens needs to be removed
from hundreds of UI files... two times for UIKit and AppKit.

### Phase 3 (2022-Current)

I wanted to learn SwiftUI and because SwiftUI was finally becoming full-featured
enough to support apps with complex navigation for both iOS and macOS, I decided
to take on the challenge. This required significant updates to the Database
wrapper to support SwiftUI's dynamic data model. However, it worked. I was able
to delete thousands of lines of platform specific UI code and replace it with
just one SwiftUI codebase. As well, I learned to love SwiftUI. If you can figure
out how to let go and let the data drive your application, SwiftUI is simply
amazing. The way the it dynamically updates when there are literally hudreds
of database changes happening every second \(such as during a sync operation\)
is incredible. SwiftUI is truly a gamechanger

## Current Status

I still use Hipstapaper across my devices daily. However, I have never put it 
on the App Store or anything like that as I know it is missing key features
that people will want such as offline reading of webpages. Yes, the link to
the web page is stored offline in the database, but to actually open the web
page you will need an internet connection.

