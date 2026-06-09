---
layout: post
title: "De-Enshittifying My Life with AI: Reverse Engineering the Tools I Use Every Day"
titleAccessory: "<i class='apl-device-iphone-5-black-256 reflect below-md round-none'></i>"
excerpt: "Cory Doctorow coined 'enshittification' to describe how platforms inevitably degrade for their users. I'm fighting back by using AI to reverse engineer and rewrite the software I rely on — starting with LINE Messenger, which I've rebuilt as ENIL so it runs on OS X 10.4+ and iOS 4.3+."
categories: [Retro-Tech]
tags: [Reverse-Engineer, iOS, Hobby, AI, LINE]
---
{::options toc_levels="1,2,3" /}

## Table of Contents

* TOC
{:toc}

## Overview

If you've been following my blog, you know I've become a little obsessed with
using vintage Apple hardware as daily drivers. My iMac G4 running Mac OS X
10.5.8 and my iPhone 5 running iOS 6.1.3 are not museum pieces gathering dust —
they're machines I actually use, every day, for real work and real
communication.

But using vintage hardware in 2026 presents an obvious problem: software. Modern
apps don't run on these old operating systems, and the apps that do still run
are increasingly broken as services shut down their old APIs, change their
protocols, or simply stop supporting anything that isn't the latest version.

This is where **enshittification** comes in — and more importantly, how I'm
fighting back against it.

## What is Enshittification?

[Cory Doctorow](https://pluralistic.net/) coined the term
**"enshittification"** to describe the lifecycle of online platforms:

1. **First, they are good to their users.** They offer a great experience to
   attract a large user base.
2. **Then, they abuse their users to benefit business customers.** They
   gradually degrade the experience, inserting ads, selling data, and locking
   down features.
3. **Finally, they abuse those business customers to claw back all the value for
   themselves.** The platform becomes a walled garden that serves only its own
   shareholders.

Sound familiar? It should. We've watched it happen to Google Search, Facebook,
Twitter, Reddit, and yes — messaging apps like LINE.

LINE Messenger is a perfect case study in enshittification. What started as a
clean, fast messaging app has become a bloated super-app crammed with
advertisements, "LINE Points," NFT marketplaces, AI chatbots nobody asked for,
and a dozen other features that exist only to extract value from users rather
than to serve them. It's no longer a messaging app — it's an advertising
platform that happens to let you send messages.

And critically for me: **LINE no longer works on iOS 6 or Mac OS X 10.5.** The
old versions that did run have been shut out as LINE updated its server
protocols and deprecated old API endpoints. Even if you could somehow install an
old IPA, it wouldn't connect because the server won't talk to it anymore.

This is enshittification in its purest form: the software I relied on was taken
away from me, not because of any technical limitation, but because the company
behind it decided my vintage hardware wasn't worth supporting.

## De-Enshittification: The Counter-Strategy

If enshittification is the disease, **de-enshittification** is the cure. And
the weapon I'm using to fight it is AI.

Here's the strategy in a nutshell:

1. **Identify the tool** that has been enshittified or abandoned.
2. **Reverse engineer the protocol** it uses to communicate with the server.
3. **Rewrite a client** that does only what I need, targeting the operating
   systems I actually use.
4. **Use AI as an accelerator** for every step of this process.

This isn't about nostalgia. It's about **software sovereignty** — the ability to
run the tools I depend on, on the hardware I choose, without asking permission
from anyone.

## ENIL: LINE Messenger, De-Enshittified

<i class='apl-device-iphone-5-black-256 reflect below-sm round-none'></i>

The first and most important project in my de-enshittification effort is
**ENIL** — LINE spelled backwards. It's a from-scratch, reverse-engineered LINE
Messenger client that runs on:

- **Mac OS X 10.4 Tiger** and newer (PowerPC and Intel)
- **iOS 4.3** and newer (armv7, including the iPhone 5 on iOS 6)

Yes, I use this **every single day** on my iPhone 5 running iOS 6.1.3. It sends
and receives messages, handles group chats, and does everything I actually need
LINE to do — without the advertisements, without the bloat, without the NFT
marketplace that I cannot even begin to express how little I care about.

### How ENIL Was Built

I'm not going to pretend this was easy. LINE's protocol is proprietary,
undocumented, and — like any good chat app — encrypted. But here's the thing:
with modern AI tools, reverse engineering a protocol is no longer the
multi-year, team-of-specialists undertaking it once was.

The process looked roughly like this:

1. **Capture the traffic.** I set up a proxy to inspect the HTTPS requests made
   by the official LINE app on a modern device. This gave me the API endpoints,
   request structures, and response formats.

2. **Decompile the official client.** Using tools like Hopper Disassembler and
   class-dump, I examined the official LINE iOS app to understand the request
   signing mechanism, authentication flow, and data model.

3. **Ask AI to explain what I'm looking at.** Every time I hit a function I
   didn't understand, an encrypted blob I couldn't parse, or a handshake
   sequence that seemed nonsensical, I fed it to an AI and asked it to explain
   what was happening. The AI didn't do the work for me — but it dramatically
   accelerated my ability to understand unfamiliar code and protocols.

4. **Iterate.** Write a test request → it fails → ask AI why it might have
   failed → adjust → try again. This loop, which used to take hours of reading
   documentation that doesn't exist, now takes minutes.

5. **Build the client.** Once I understood the protocol well enough, I wrote a
   clean, minimal Objective-C client targeting the lowest common denominator:
   iOS 4.3 and Mac OS X 10.4. No Swift, no modern APIs, no dependencies that
   wouldn't compile on a PowerPC Mac. Just pure, portable Objective-C that
   compiles with GCC 4.2 and runs on armv7.

### What ENIL Does (and Doesn't) Do

ENIL is not a full LINE client. It doesn't support stickers, LINE Pay, LINE
Today, LINE VOOM, or any of the other LINE-branded things that LINE has bolted
onto LINE over the years. It does:

- ✅ Send and receive text messages
- ✅ Group chats (read and send)
- ✅ Contact list
- ✅ Message history
- ✅ Push notifications (via a lightweight background service)
- ✅ End-to-end encryption (using the same protocol LINE uses)

It doesn't:

- ❌ Stickers (I'm not 12)
- ❌ Ads (obviously)
- ❌ Any LINE "services" beyond messaging
- ❌ Require iOS 15 or a Mac from the last 5 years

In other words, it's LINE as LINE should have stayed: a fast, reliable messaging
app that respects your time and your hardware.

## Why AI Changes Everything

Let me be clear: I am not using AI to write all my code for me. AI-generated
code is often mediocre at best and actively harmful at worst. But that's not
where AI shines in this workflow.

AI is transformative in three specific ways:

### 1. Protocol Analysis

When you're staring at a hex dump of an encrypted payload or a decompiled
function with 200 branches, the hardest part is knowing where to start. AI can
look at that same blob and say: "This looks like an AES-256-CBC encrypted
payload with a 16-byte IV prepended, and the key is probably derived from this
token you saw in the login response." It's not always right, but it gives you a
starting hypothesis that would have taken days to formulate on your own.

### 2. Bridging Documentation Gaps

LINE's protocol has no documentation. But many of the patterns it uses —
protobuf serialization, OAuth2 token flows, certain encryption schemes — are
well-documented elsewhere. AI knows about these patterns and can say: "This
looks like a standard OAuth2 refresh flow, except they've added a custom header
that's probably a timestamp-based signature." Again: not always right, but
incredibly useful as a first pass.

### 3. Explaining Unfamiliar Code

I'm comfortable with Objective-C and Cocoa, but I'm not a security researcher. I
don't know every encryption library, every hashing algorithm, every certificate
pinning technique. When Hopper shows me a function calling
`SecTrustEvaluateWithError` with a custom policy, I can ask AI to walk me
through what's happening line by line. This turns "I have no idea what I'm
looking at" into "oh, they're doing certificate pinning with a custom root CA"
in about 30 seconds.

## The Bigger Picture

ENIL is just the first project. The same approach — AI-assisted reverse
engineering followed by a clean reimplementation — can be applied to any
software that has been enshittified, abandoned, or locked down.

Some other projects I'm considering:

- **A native YouTube client** for iOS 6 that doesn't require the Google
  framework behemoth
- **A Twitter/X client** that talks directly to the API without the algorithmic
  feed
- **A Maps client** that uses OpenStreetMap data rendered natively

The common thread is simple: **I want my software to serve me, not the company
that made it.** And with AI, I finally have the leverage to make that happen
without spending a decade on each project.

## The Philosophy

There's a certain kind of person who will read this and say: "Why don't you just
buy a new phone?" And to that person, I say: you're missing the point entirely.

I don't use an iPhone 5 because I can't afford a newer phone. I use it because I
**prefer** it. It's smaller. It's lighter. It has a headphone jack. iOS 6 is the
last version of iOS that felt like it was designed for humans rather than for
engagement metrics. Every interaction is fast, predictable, and intentional.

The same goes for my iMac G4. It's a beautiful machine running an operating
system that respects me. Mac OS X Tiger and Leopard didn't have telemetry, 
didn't have forced updates, didn't have ads in the operating system. They were
tools, not platforms.

Enshittification is not inevitable. It's a choice made by companies that have
decided their users are products rather than customers. And de-enshittification
— reclaiming your software, your hardware, and your digital life — is a choice
too. It's a choice I'm making, and with AI, it's more achievable than ever.

## What's Next

ENIL is working great, but it's not open source yet. There are some
authentication details I'm still working through that would make it too easy to
abuse LINE's servers if released publicly. Once I have those sorted out, I plan
to release the source code so other vintage hardware enthusiasts can de-enshittify
their messaging experience too.

In the meantime, if you're interested in the de-enshittification movement —
building simple, fast, user-respecting software for the platforms you actually
want to use — please reach out. I'm particularly interested in hearing from
anyone who has reverse engineered other messaging protocols or who wants to
collaborate on clients for vintage platforms.

<i class='apl-computer-imac-g4-17-256 reflect below-sm round-none'></i>
<i class='apl-device-iphone-5-black-256 reflect below-lg round-none'></i>

The future is old. And it's de-enshittified. <i class="fa-solid fa-rainbow"></i>
