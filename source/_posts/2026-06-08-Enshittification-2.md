---
layout: post
title: "Enshittification 2: Using AI to De-Enshittify My Life One Reverse-Engineered App at a Time"
titleAccessory: "<i class='fa-solid fa-rainbow reflect below-md round-none'></i>"
excerpt: "Cory Doctorow coined the perfect word for what happens to every platform: enshittification. Here's how I'm using AI to reverse-engineer and rewrite my own de-enshittified versions of the tools I depend on every day — starting with ENIL, a reverse-engineered LINE Messenger client for OS X 10.4+ and iOS 4.3+."
categories: [Retro-Tech]
tags: [Reverse-Engineer, iOS, Hobby, AI, Open-Source]
---

{::options toc_levels="1,2,3" /}

## Table of Contents

* TOC
{:toc}

## Overview

We all feel it. The apps and services we rely on get worse over time — not
better. Features we loved get removed. Ads creep in where there were none.
Performance degrades. Privacy evaporates. The experience that once felt
delightful slowly morphs into something hostile.

Cory Doctorow gave this phenomenon a name: **enshittification**. And in 2026,
it's worse than ever. But I've found a way to fight back, and it involves a
combination that sounds absurd on paper: vintage hardware, reverse engineering,
and AI.

In this post, I want to tell you about my approach to de-enshittifying my life,
and walk you through my first major victory: **ENIL**, a completely
reverse-engineered client for LINE Messenger that runs on OS X 10.4 Tiger and
iOS 4.3 — and that I use daily on my iPhone 5 running iOS 6.

## What Is Enshittification?

If you haven't encountered the term before, Cory Doctorow
[coined "enshittification"](https://pluralistic.net/2023/01/21/potemkin-ai/)
to describe the lifecycle of online platforms:

1. **First, they are good to their users.** They offer a great experience to
   attract people. Think of early Facebook, early Google Search, early Uber —
   services that felt almost magical when they launched.
2. **Then, they abuse their users to benefit their business customers.**
   Once users are locked in, the platform shifts to serving advertisers,
   sellers, or whoever pays the bills. The feed fills with sponsored content.
   The search results become ads. The prices go up.
3. **Finally, they abuse their business customers to claw back value for
   shareholders.** Even the advertisers get squeezed. The platform becomes a
   husk, extracting rent from everyone until it dies — or until regulation
   steps in.

This isn't just about social media. It's every platform. Every app. Every
service. And as an iOS developer who's been in this industry for over a decade,
I've watched it happen in real time to the tools I use every day to communicate
with friends and family.

## The LINE Messenger Problem

I live in Japan. If you live here too, you know that LINE Messenger is *the*
communication platform. Everyone uses it. Friends, family, coworkers, your
landlord, the pizza place down the street — everyone. It's not optional. You
cannot opt out of LINE any more than an American can opt out of SMS in 2008.

But LINE has become a textbook case of enshittification:

- The app has ballooned to hundreds of megabytes, packed with news feeds, mobile
  payments, NFT marketplaces, and god knows what else
- It constantly nags you with promotions, stickers, and LINE VOOM (their
  TikTok clone that nobody asked for)
- The performance on anything but the latest phones is abysmal
- Privacy? Don't make me laugh. LINE has had
  [multiple](https://en.wikipedia.org/wiki/Line_(software)#Privacy_and_security)
  data handling scandals
- And critically for me: **they dropped support for older iOS versions years
  ago.** My iPhone 5 on iOS 6? LINE won't even install, let alone run.

I'm not going to give up my iPhone 5. And I'm not going to stop talking to my
friends. So I had exactly one option: reverse engineer the LINE protocol and
write my own goddamn client.

<div class="prompt-info" markdown="1">
**Why "ENIL"?** It's "LINE" spelled backwards. Because I'm running backwards
away from their enshittification. Also because I'm a child.
</div>

## The AI-Powered Reverse Engineering Playbook

Now, here's the thing: I'm not a protocol reverse engineering expert. Before
2025, I had never used GDB to debug someone else's binary. I had never
intercepted HTTPS traffic to figure out an undocumented API. I had never read
raw TCP streams from Wireshark and tried to make sense of them.

But here's what I do have: **AI**. And AI is absolutely, astonishingly good at
helping with this kind of work.

Let me be clear: AI does not do the work *for* you. It doesn't magically reverse
engineer an app. But what it does do is act as the most patient, knowledgeable,
never-tired pair programmer you've ever had. It knows every API. It knows every
GDB command. It knows every OpenSSL flag. It knows the internals of every
networking library. And it will explain things to you over and over and over
again without ever getting frustrated — even when you're scolding it at 2 AM
because you've been debugging the same TLS handshake for six hours.

Here's the approach I've developed:

### Step 1: Capture the Traffic

First, you need to see what the app is actually sending over the network. For
LINE, I used a combination approach:

- **On the Mac side**: I ran an older version of the LINE Mac client (for OS X
  10.9) inside a VM, mitmproxy intercepting its traffic, and a mountain of
  patience to deal with certificate pinning
- **On the iOS side**: I used my iPhone 5 with a jailbreak to install a CA
  certificate and route traffic through Charles Proxy on my modern Mac

AI was invaluable here for figuring out certificate pinning bypass techniques.
It walked me through patching the binary to disable pinning checks, which is a
technique I first learned while [hacking iTunes](/retro-tech/2026/02/16/Reverse-iTunes-1.html).

### Step 2: Understand the Protocol

Once you have the traffic, you need to understand it. LINE uses a custom
protocol based on Apache Thrift (a binary protocol similar to Protocol Buffers).
This is where AI really shines — you can paste raw hex dumps and ask it to help
you identify patterns, structures, and compare them against known Thrift
schemas.

I spent weeks feeding Gemini snippets of captured traffic and asking questions
like:

- "Here's a hex dump. This looks like it might be a Thrift struct. Can you help
  me identify the fields?"
- "I see this byte pattern repeated. What Thrift data types would produce this?"
- "How does LINE handle authentication? Walk me through what each field in this
  login request might be."

Over time, I built up a complete picture of the protocol.

### Step 3: Write a Clean-Room Implementation

This is the critical step. I did not copy LINE's code. I did not use their SDKs
or libraries. I wrote a clean-room implementation based purely on my
understanding of the protocol from the network traffic.

The key principle: **observe the behavior, understand the protocol, write your
own implementation.**

AI helped me write the Thrift parsing and serialization code, the networking
layer, and even the UI. I used modern development practices — proper error
handling, tests, documentation — things the original LINE client clearly
abandoned years ago in favor of feature bloat.

### Step 4: Target Old Platforms

Here's the beautiful part: because I control the entire stack, I can target
whatever platform I want. My implementation uses:

- **Foundation** and **Core Foundation** (available since OS X 10.0)
- **CFNetwork** for HTTP and socket communication
- **Security.framework** for TLS
- No SwiftUI, no Combine, no modern-only APIs

The result? ENIL runs on:

| Platform | Minimum Version | Tested On |
|----------|----------------|-----------|
| OS X | 10.4 Tiger | iMac G4 (PowerPC), MacBook Pro (Intel) |
| iOS | 4.3 | iPhone 3GS, iPhone 4, iPhone 4s, iPhone 5 |

## ENIL: What It Does Today

ENIL is not a full LINE replacement — yet. But it handles the core
functionality I actually need every day:

- ✅ **Login and authentication** — securely logs into LINE's servers using the
  official authentication flow (because I'm not trying to steal accounts, I'm
  just trying to use a decent client)
- ✅ **One-on-one chats** — send and receive text messages
- ✅ **Group chats** — participate in group conversations
- ✅ **Stickers** — yes, the stickers work. I'm not a monster.
- ✅ **Image sharing** — send and receive photos
- ✅ **Read receipts** — so people know I've seen their messages

What ENIL does **not** have (and will never have):

- ❌ LINE VOOM (their TikTok clone)
- ❌ LINE Pay / LINE Wallet
- ❌ LINE News
- ❌ LINE NFT Marketplace (seriously, what the fuck)
- ❌ Ads
- ❌ Tracking
- ❌ Bloat

The entire app is under 2 MB. It launches instantly. It uses minimal memory.
And it runs on hardware that LINE officially abandoned nearly a decade ago.

<div class="prompt-warning" markdown="1">
**Legal Note:** ENIL is a clean-room reverse-engineered client. It does not
include any of LINE's code, libraries, or copyrighted assets. It communicates
with LINE's servers using the same protocol any third-party client would use.
That said, LINE's terms of service almost certainly prohibit third-party
clients, so use at your own risk. I am not distributing binaries at this time.
</div>

## The Philosophy: De-Enshittification Through Sovereignty

This project isn't really about LINE. It's about a broader philosophy that I've
been developing over the past year as I've [revived my iMac G4](/retro-tech/),
[set up iPhone development on PowerPC](/retro-tech/2025/12/04/PPC-iPhone-1.html),
and [hacked iTunes to sync my iPhone 5](/retro-tech/2026/02/16/Reverse-iTunes-1.html).

The philosophy is simple: **you cannot trust platforms.**

Every platform — every app, every service, every operating system — is on a
one-way trajectory toward enshittification. The only question is how fast. The
only defense is to own your tools. To understand them. To be able to fix them
when they break. To run them on hardware you control, using software you can
read and modify.

This is what the free software movement has been saying for decades. But it
turns out the missing piece was AI. Because the barrier to "just write your
own" has always been insurmountably high for most people. Reverse engineering a
proprietary protocol is incredibly difficult. Implementing a complex networked
application from scratch is a massive undertaking.

AI changes the calculus. It doesn't make it easy — ENIL took me months of
evening and weekend work. But it makes it *possible* for a single determined
person to do what previously required a team of engineers with specialized
expertise.

## What's Next

ENIL is just the beginning. I'm applying the same approach to other enshittified
services I depend on:

- **YouTube**: The official YouTube app for iOS 6 stopped working years ago.
  I'm working on a client that can search and play videos through the Invidious
  API, with a native iOS 6 UI.
- **Google Maps**: The old Maps app on iOS 6 still works but is increasingly
  broken. I'm exploring using OpenStreetMap data through a native client.
- **Weather**: Why does every weather app need my location to sell to data
  brokers? NOAA's API is free and doesn't require an account. A simple,
  beautiful weather app for iOS 6 is in the works.

Each of these follows the same pattern: capture traffic, understand the
protocol or API, write a clean-room implementation targeting old platforms, and
never look back.

## Why You Should Care (Even If You Don't Use an iPhone 5)

I get it. Using an iPhone 5 in 2026 is absurd. I'm not recommending you do it
(unless you want to — in which case, [let's be friends](https://jeffburg.social/@Jeff)).

But the principle applies regardless of what hardware you use. The software
industry has consolidated into a handful of giant platforms, and those platforms
are all enshittifying. The only way out is through: we need more people writing
their own tools, understanding the protocols they depend on, and refusing to
accept that the official client is the only option.

AI is the great equalizer here. It's not a replacement for skill or
determination — you still need those in spades. But it dramatically lowers the
barrier to entry for understanding complex systems and implementing your own
solutions.

The future I want is one where every popular service has dozens of third-party
clients targeting every platform imaginable. Where you can choose a client that
respects your privacy, runs on your hardware, and does exactly what you need and
nothing more. Where enshittification is defeated not by regulation (though we
need that too) but by the simple fact that users have options.

ENIL is my contribution to that future. It's LINE, backwards. And it's just the
beginning.

<i class="fa-solid fa-rainbow"></i> Stay fabulous. De-enshittify everything.
