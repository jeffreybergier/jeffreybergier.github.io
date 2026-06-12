---
layout: post
title: "Enshittification 6: ENIL — A Reverse-Engineered LINE Messenger"
titleAccessory: "<i class='fa-solid fa-poo fa-4x reflect below-xs round-none'></i>"
excerpt: "LINE Messenger has a special place in Japan but it has been enshittifying for years. I used AI to reverse-engineer the LINE protocol and wrote my own client — ENIL — that runs on OS X 10.4+ and iOS 4.3+. I use it daily on my iPhone 5 running iOS 6."
categories: [Retro-Tech]
tags: [Reverse-Engineer, iOS, OS-X, Hobby, AI]
---

{::options toc_levels="1,2,3" /}

* TOC
{:toc}

## What Is Enshittification?

In 2022, Cory Doctorow coined the term [**enshittification**](https://en.wikipedia.org/wiki/Enshittification) to describe the pattern by which online platforms degrade over time. First they are good to their users; then they abuse their users to attract business customers; finally they abuse those business customers to claw back all the value for themselves. The platform you once loved becomes a bloated, ad-infested, privacy-violating husk of its former self.

This pattern is not limited to platforms like Amazon or Facebook. It applies just as well to messaging apps, operating systems, and nearly every piece of software that depends on a corporate server. And LINE Messenger — the dominant chat app in Japan — is a textbook case.

LINE started as a clean, fast messaging app born out of the 2011 Tōhoku earthquake. It was beautiful in its simplicity. But over the years it has accumulated: ads in the chat list, a crypto wallet, NFTs, a stock trading platform, news tabs, short-form video feeds, avatar stickers, and AI chatbots nobody asked for. Every feature clogs the app and every "service" mines your data. The app that once loaded instantly now takes seconds. The chat list that was once clean now has ads injected between your friends' names.

But it gets worse. LINE has also been dropping support for older devices. The iOS 6 version of LINE was shut down long ago. The modern app requires iOS 15 or later. If you want to use LINE to talk to friends and family in Japan, you are forced to use a modern smartphone with a modern OS that is itself enshittifying under your feet.

I refuse.

## Un-Enshittifying My Life with AI

Over the last few years, I have been systematically replacing the enshittified software in my life with my own reverse-engineered alternatives. Each project follows the same pattern:

1. **Identify** a piece of software that has been enshittified beyond tolerance.
1. **Capture** its network traffic to understand the protocol.
1. **Reverse-engineer** the protocol with the help of AI — Gemini, Claude, whatever is available.
1. **Rewrite** my own client that does only what I need and nothing else.
1. **Deploy** it on my vintage hardware and use it daily.

This is project number six in that series. Hence the title: **Enshittification 6**.

The previous five projects are not yet documented on this blog, but they include a reverse-engineered YouTube client for iOS 6, a custom weather app that scrapes a simple API instead of loading 47 JavaScript frameworks, and a few others I will write up when time permits. Each one chips away at the mountain of enshittified cruft and returns a little piece of my digital life to something I actually control. Each one was built with significant help from AI — not because AI is magic, but because it is an incredible force multiplier for the tedious parts of reverse engineering: disassembling, deobfuscating, and generating boilerplate protocol code.

### How AI Helps (and How It Doesn't)

Let me be clear: AI cannot do this work for you. If you ask an AI "reverse engineer LINE Messenger for me," it will produce confident-sounding nonsense. But if you use AI as a pair programmer — feeding it hex dumps, asking it to explain network traces, having it generate test stubs, and using it to bounce ideas — it becomes an incredibly powerful tool.

The workflow looks something like this:

1. Set up a MITM proxy (I use [mitmproxy](https://mitmproxy.org/) on a modern machine) and capture traffic between the official LINE app and LINE's servers.
1. Feed the captured request/response pairs to an AI and ask it to identify patterns, suggest what each field might mean, and propose a protocol specification.
1. Write a minimal test client, have the AI help debug connection issues, and iteratively flesh out the protocol.
1. Once the protocol is understood, have the AI generate the model types, serialization code, and network layer in Objective-C (or whatever language targets your vintage platform).
1. Build the UI by hand — this is the part where AI is least helpful, because vintage UIKit and AppKit are not well represented in training data.

The AI is not the hero of this story. It is a very enthusiastic, somewhat unreliable intern who happens to have memorized every RFC and can type at 10,000 words per minute. You the human still need to be the architect, the code reviewer, and the one who actually understands what is happening end-to-end. But without AI, I simply would not have the time to do six of these projects. With AI, each one takes a few weeks of evenings and weekends instead of months.

## ENIL: LINE Messenger in Reverse

**ENIL** is exactly what it sounds like: LINE spelled backwards. It is a clean, minimal LINE client that does exactly four things:

- Send and receive text messages
- Display stickers (the classic LINE stickers, not the animated NFT garbage)
- Show read receipts
- Maintain a contact list

That is it. No ads. No crypto wallet. No news feed. No AI chatbot. No short-form video. Just the core messaging functionality that made LINE popular in the first place.

### Technical Details

ENIL implements a subset of the [LINE Thrift protocol](https://thrift.apache.org/) (also known as the "Talk" protocol). LINE's backend uses Apache Thrift for most of its API calls, with a custom binary framing layer. The main operations ENIL supports are:

| Operation | LINE Internal Name | Description |
|-----------|-------------------|-------------|
| Login | `loginZ` | Authenticate with email/password and get an auth token |
| Fetch contacts | `getAllContactIds` | Retrieve the contact list from LINE's servers |
| Fetch profile | `getProfile` | Get display name and profile picture URL for each contact |
| Receive messages | `fetchOperations` | Long-poll for new messages and delivery receipts |
| Send messages | `sendMessage` | Send a text message to a contact |
| Fetch stickers | N/A (HTTP) | Download sticker images from LINE's CDN |

The protocol uses a custom binary encoding over TLS with certificate pinning. Bypassing the certificate pinning was the hardest part of the reverse engineering process. The official LINE app pins LINE's own CA certificate and refuses to talk to any server that does not present a certificate signed by that CA. This is a reasonable security measure — it prevents MITM attacks — but it also prevents you from inspecting your own traffic.

Without AI, I might have spent weeks trying to patch the certificate pinning checks in the disassembled iOS binary. With AI, I was able to identify the pinning logic, understand that LINE embeds a pinned public key hash rather than a certificate, and then extract the correct key material from the app binary. From there, I could configure mitmproxy to present a certificate that matches the pinned key, and suddenly all the traffic was visible.

### Platform Support

ENIL targets the platforms I actually use:

| Platform | Minimum Version | Architecture | Framework |
|----------|----------------|--------------|-----------|
| OS X | 10.4 Tiger | PowerPC G3+ and Intel | Cocoa / AppKit |
| iOS | 4.3 | armv6, armv7 | UIKit |
| iOS (modern fallback) | 6.1.3 | armv7s | UIKit |

Why such old targets? Because the entire point of this exercise is to escape the enshittification treadmill. I want to use my iPhone 5 running iOS 6.1.3 as my daily driver. iOS 6 predates most of Apple's own enshittification — no nagging to upgrade, no "Sign in to iCloud" popups every five minutes, no apps that refuse to launch because the OS is "too old." The OS is frozen in a state where it was still genuinely good. The only thing that makes it "obsolete" is that corporations decided to stop supporting it.

On the Mac side, ENIL works all the way back to OS X 10.4 Tiger on PowerPC. This means I can run it on my iMac G4. I do not actually use LINE on a PowerPC Mac — the 1.25 GHz G4 is not exactly a chat powerhouse — but the fact that it works is a testament to how lightweight a properly-written Cocoa app can be. ENIL's entire codebase is about 1,500 lines of Objective-C. The official LINE app for Mac is over 100 MB. I rest my case.

### Daily Use on iPhone 5

I have been using ENIL daily on my iPhone 5 running iOS 6.1.3 for about three months now. Is it perfect? No. There are rough edges:

- **Push notifications do not work.** iOS 6 supports push notifications just fine, but I would need to run a push notification server that receives messages from LINE's servers and forwards them to APNs. That is a project for another day. For now, I just open ENIL to check for new messages manually, like an animal.
- **Images are not supported.** My wife sends me photos of our cats on LINE all day and I have to view them on my modern phone. Supporting image messages is on the roadmap but the binary format for LINE's image attachments is different from the text message format and I have not had time to reverse-engineer it yet.
- **Group chats are read-only.** I can see messages in group chats but I cannot send to them. The group send protocol uses a different endpoint that I have not fully reverse-engineered.

But for 90% of my daily LINE usage — text messages, stickers, and read receipts — ENIL works flawlessly. It loads instantly. It uses almost no battery. It has zero tracking. It does not show me ads. It does not suggest I buy crypto. It just lets me talk to my wife and friends, which is what a messaging app is supposed to do.

## The Bigger Picture

ENIL is not just about LINE. It is part of a larger philosophy: **software does not have to be enshittified.** The cycle is not inevitable. You can opt out.

Corporations want you to believe that you need their apps, their platforms, their servers, their updates. They want you to believe that reverse engineering is impossible or illegal or both. They want you to believe that you are helpless.

You are not helpless.

Reverse engineering for interoperability is legal in most jurisdictions (including Japan and the US). More importantly, it is technically achievable for a determined individual with modern AI tools. The protocols these companies use are not magical; they are just bytes on a wire. And with enough patience, you can understand those bytes and write your own code that speaks the same language.

Every enshittified app you replace with your own is a small victory. It is one less vector for surveillance. One less source of ads. One less piece of software that treats you like the product instead of the customer. And perhaps most satisfyingly, it means you can keep using the hardware you love — your iPhone 5, your iMac G4, your PowerBook — without being locked out by artificial software restrictions.

## What Is Next?

I plan to continue this series as I complete more reverse-engineering projects. The next one will probably be a write-up of my reverse-engineered YouTube client for iOS 6, which was Enshittification Project #3. That one was particularly satisfying because Google has enshittified YouTube so thoroughly that the official app barely functions even on modern hardware.

But for now, ENIL is working. My iPhone 5 buzzes (well, it would buzz if I had push notifications working) with LINE messages from my wife, and my world is just a little bit less enshittified than it was before.

If you are interested in the source code for ENIL or any of my other reverse-engineering projects, reach out. I have not published them yet — partly because I am still cleaning up the code and partly because I want to make sure I am not violating any laws in Japan — but I am happy to share with fellow retro-computing enthusiasts.

<i class="fa-solid fa-poo fa-4x reflect below-xs round-none"></i>
<i class="fa-solid fa-arrow-right fa-2x"></i>
<i class="fa-solid fa-star fa-4x reflect below-xs round-none"></i>
