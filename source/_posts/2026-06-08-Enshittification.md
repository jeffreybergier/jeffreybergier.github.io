---
layout: post
title: "De-Enshittifying My Life with AI and Reverse Engineering"
titleAccessory: "<i class='apl-device-iphone-5-black-256 reflect below-md round-none'></i>"
excerpt: "Software enshittification is real — apps get worse every year as companies squeeze users for profit. But AI is changing the game. I'm using LLMs to reverse-engineer and re-write the tools I depend on, starting with ENIL, a from-scratch LINE Messenger client that runs on iOS 4.3+ and OS X 10.4+."
categories: [Retro-Tech]
tags: [Reverse-Engineer, iOS, PowerPC, Hobby, AI, LINE]
---
{::options toc_levels="1,2,3" /}

## Table of Contents

* TOC
{:toc}

## Overview

In this article, I want to talk about a concept that has come to define the
modern software experience: **enshittification**. Coined by Cory Doctorow, it
describes the lifecycle of online platforms — first they're good to their users,
then they abuse their users to benefit business customers, then they abuse
everyone to benefit shareholders until there is nothing left but a pile of crap.

But this isn't a doom-scroll article about how everything sucks now. This is
about how AI — specifically Large Language Models — is giving individual
developers the power to fight back. I'm going to walk you through my philosophy
of **AI-assisted de-enshittification** and show you a concrete example: ENIL, my
reverse-engineered LINE Messenger client that I built from scratch and use daily
on my iPhone 5 running iOS 6.

## What is Enshittification?

If you've used software for more than 5 minutes in the last decade, you've felt
it. An app you loved gets a redesign that buries the feature you use behind
three menus. A chat app starts injecting ads between your conversations. A
service you paid for suddenly becomes a subscription, then the subscription
price doubles, then the free tier you convinced your friends to use gets
cancelled. That's enshittification.

Doctorow's framework is useful because it names the pattern:

1. **Phase 1: Be good to users.** Build a great product, attract a huge user
   base, burn VC money if you have to. The user is the product's *raison d'être*.
1. **Phase 2: Be good to business customers.** Once you have locked-in users,
   start making changes that benefit advertisers, enterprise clients, or data
   brokers — even if it hurts the user experience.
1. **Phase 3: Be good to shareholders.** When there's nothing left to extract
   from either side, hollow out the product entirely. Shrink the team, automate
   support into oblivion, and coast on brand recognition until the wheels fall
   off.

Sound familiar? It should. It's basically every messaging app, every social
network, every productivity tool, every cloud service. The software industry has
been running this playbook for 20 years and we're all exhausted.

## AI Changes the Calculus

Here's the thing about Phase 1 software: it was built by small teams of
motivated engineers solving real problems. The codebase was manageable. The
protocols were simpler. The feature set hadn't yet ballooned into an
unmaintainable mess designed by committee.

The tragedy is that when Phase 3 software inevitably dies, it takes the Phase 1
experience with it. You can't just install the 2008 version of LINE Messenger on
your iPhone 5 — the servers are gone, the protocols have changed, and none of
the old binaries even run on modern systems.

But here's where AI changes everything. Large Language Models are really, really
good at:

- **Explaining unknown protocols.** Give an LLM a packet capture and it can help
  you understand the wire format faster than weeks of manual reverse engineering.
- **Writing boilerplate.** The boring parts of a network client — HTTP requests,
  JSON/Protobuf parsing, threading models — are exactly the kind of code LLMs
  excel at generating.
- **Translating between languages and frameworks.** Need to port a C++
  networking stack to Objective-C for PowerPC? An LLM can do the mechanical
  translation while you focus on the architecture.
- **Understanding legacy APIs.** Ever tried to find documentation for
  `CFStreamCreatePairWithSocketToHost` from 10.4 era? The LLM already read all
  of that and can explain it to you.

The point is not that AI writes perfect code — it doesn't. The point is that AI
*dramatically lowers the barrier* to reverse engineering and reimplementing the
software you depend on. What used to take a team of engineers months can now be
done by one motivated person with the right tools.

This is the promise of AI-assisted de-enshittification: **if a service has
enshittified itself beyond usability, you can just build a Phase 1-quality
client yourself.**

## ENIL: A Concrete Example

The poster child for my de-enshittification strategy is ENIL — my
reverse-engineered LINE Messenger client.

### Why LINE?

LINE is the dominant messaging platform in Japan and several other Asian
countries. It's how everyone communicates. It's where work happens, where
friends plan outings, where family groups share photos. You can't *not* use it.
But LINE's native clients have been enshittifying at an alarming rate:

- The iOS client dropped support for iOS 6 years ago
- The macOS client dropped support for OS X 10.4–10.10
- Newer versions are bloated with ads, stickers, games, payments, news feeds,
  and a hundred other "features" that don't belong in a messaging app
- The UI has been redesigned so many times the original clean Japanese aesthetic
  is completely gone
- Privacy? Don't make me laugh honey

### What ENIL Does

ENIL is a clean, from-scratch reimplementation of LINE Messenger. It speaks
LINE's protocol directly — no reverse-engineered SDKs, no shims. It handles:

- Sending and receiving text messages
- Group chats
- Image sharing
- Stickers (the good ones, not the new creepy animated ones)
- Contact list syncing
- Push notifications (on supported platforms)

And it does all of this on:

- **iOS 4.3 through iOS 9** (I use it daily on my iPhone 5 running iOS 6.1.3)
- **OS X 10.4 Tiger through OS X 10.11 El Capitan** (including PowerPC Macs
  running 10.4 and 10.5)

### How AI Helped Build It

I'm not going to sugar-coat it: reverse-engineering LINE's protocol was work.
LINE uses a custom protocol built on top of HTTP long-polling and a binary
serialization format called Thrift. The protocol has multiple layers of
encryption and authentication. It's not documented publicly.

But here's how AI accelerated the process:

**Protocol Discovery.** I captured traffic between the official LINE client and
LINE's servers using mitmproxy. I fed the packet captures to Gemini (but any
LLM would work) and asked it to help me identify patterns. It correctly
identified the Thrift serialization, the handshake sequence, and the session
token flow. What would have taken me weeks of staring at hex dumps took a few
evenings of guided analysis.

**Boilerplate Generation.** LINE's protocol involves dozens of Thrift struct
definitions. Writing all of those by hand in Objective-C would have been
torture. I used the LLM to generate the model classes, the serialization code,
and the HTTP plumbing. Did I have to fix bugs? Yes. Was it still 10x faster
than writing it manually? Absolutely.

**Legacy Platform Expertise.** Remember when I said OS X 10.4? The networking
APIs on 10.4 are... special. `NSURLConnection` exists but is limited.
`NSURLSession` doesn't exist at all. You're working with Core Foundation streams
and raw sockets. Documentation for this era of macOS development is sparse, but
the LLM was trained on it. It knew the APIs, the gotchas, the memory management
patterns. It was like pair-programming with a greybeard who had been writing
Mac software since 2005.

**Debugging Help.** When something broke — and things broke constantly — I could
paste the crash log or the unexpected server response into the LLM and get
useful hypotheses about what went wrong. It wasn't always right, but it was
always a faster starting point than Googling into the void.

### The Result

<div style="text-align: center; margin: 2em 0;">
<i class="apl-device-iphone-5-black-256 reflect below-sm round-none"></i>
<i class="apl-computer-imac-g4-17-256 reflect below-sm round-none"></i>
</div>

I now have a LINE client that:

- **Runs on my iPhone 5 with iOS 6** — it's fast, it's lightweight, it doesn't
  drain my battery
- **Runs on my iMac G4 with OS X 10.5.8** — a 20-year-old computer, running a
  modern messaging app, talking to 2026 servers
- **Does exactly what I need and nothing more** — no ads, no games, no news
  feed, no crypto wallet, no AI chatbot (ironic, I know)
- **I control the code** — if LINE adds a feature I don't like, I don't have to
  implement it. If they change the protocol, I can update my client. I'm not at
  their mercy anymore.

Is ENIL perfect? No. There are features missing (voice calls are hard), and
sometimes LINE's sever changes break things until I can patch them. But it works
for my daily communication needs, and that's the point. I de-enshittified LINE by
refusing to use their client and building my own.

## The Broader Philosophy

ENIL is just the first project. I'm applying this same approach to other tools:

- **iTunes syncing** — reverse-engineering the iPhone sync protocol so I can
  sync my iPhone 5 with my PowerPC Macs (I already [wrote about
  this](../16/Reverse-iTunes-1.html) earlier this year)
- **YouTube on iOS 6** — a lightweight YouTube client for vintage iOS that talks
  to YouTube's API directly (in progress, and yes YouTube is *peak*
  enshittification right now)
- **Weather** — because somehow every weather app in 2026 needs your location,
  contacts, and firstborn child to tell you it's going to rain

The pattern is the same: find a service that has enshittified itself into
uselessness, reverse-engineer the bare minimum protocol needed to use it, and
build a client that does exactly what you need and nothing more. AI makes this
feasible for individual developers in a way it never was before.

### The Tradeoffs

I'm not naive about this. There are real downsides:

- **Maintenance burden.** Every time LINE changes their server, I might have to
  update my client. This is real work.
- **Missing features.** Voice calls, video calls, and some newer LINE features
  simply aren't present in ENIL. If you need those, this approach won't work.
- **Terms of Service.** Reverse-engineering protocols to build alternative
  clients is legally grey. I'm not selling ENIL, I'm not distributing it widely,
  and I'm using it for personal communication. But it's worth being aware that
  this isn't something companies love.
- **You need to know what you're doing.** AI helps a lot, but it doesn't replace
  fundamental engineering skills. You still need to understand networking,
  security, and the platform you're targeting.

## Why This Matters

There's a certain fatalism in tech culture about enshittification. "That's just
how it is." "What are you gonna do, stop using Google Maps?" And for a long
time, that fatalism was justified. What *were* you going to do?

But AI changes the answer. You *can* do something. You can build your own
client. You can reverse-engineer the parts that matter to you. You can say no
to the bloat, the ads, the surveillance, the planned obsolescence, the forced
upgrades, the feature removals, the price hikes, the dark patterns, the "we've
updated our privacy policy" emails.

De-enshittification is not about rejecting technology — it's about reclaiming
control over the technology you use. It's about treating software as a tool
that serves you, not a service that extracts from you. And AI, for all its
very real problems, is an incredible force multiplier for anyone who wants to
take that control back.

## What's Next

I'm going to keep building. ENIL is open source if you want to check it out
(link coming soon — I need to clean up the repo before sharing). If you're
interested in this approach, here's my advice:

1. **Start small.** Pick one service you use every day that frustrates you.
1. **Capture some traffic.** mitmproxy, Wireshark, Charles Proxy — whatever
   works on your platform.
1. **Feed it to an LLM.** Ask it to help you understand the protocol. You'll be
   surprised how far you get.
1. **Build the minimum viable client.** Text messages first. One platform first.
   Get something working end-to-end before you add features.
1. **Iterate.** The LLM will help you debug, extend, and maintain.

The future of software doesn't have to be enshittified. It can be weird, it can
be personal, it can be built for you and your friends and no one else. It can
run on a 20-year-old computer if you want it to. AI gives us the leverage to
make that happen.

Now if you'll excuse me, I have some LINE messages to reply to — from my iPhone
5, using the client I built myself. <i class="fa-solid fa-heart"></i>