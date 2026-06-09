---
layout: post
title: "Enshittification 4: How AI Is Helping Me Reverse Engineer My Way Out of Enshittification"
titleAccessory: "<i class='apl-device-iphone-5-black-256 reflect below-md round-none'></i>"
excerpt: "LINE messenger went from a lightweight, fast messenger to a bloated super-app full of ads, \"news,\" crypto, and an AI chatbot. So I reverse-engineered the LINE protocol and built ENIL — a clean, fast, ad-free LINE client that runs on OS X 10.4 Tiger all the way through iOS 4.3+, and I use it daily on my iPhone 5."
categories: [Retro-Tech]
tags: [Reverse-Engineer, AI, iOS, Hobby, ENIL]

---

## Table of Contents

* TOC
{:toc}

## What Is Enshittification?

If you're reading my blog, you probably already know the term. 
[Cory Doctorow coined "enshittification"](https://pluralistic.net/2023/01/21/potemkin-ai/#hey-guys) 
to describe the predictable lifecycle of online platforms:

1. **Be good to users** — Build a great product, attract a massive user base.
2. **Be good to business customers** — Once users are locked in, squeeze them to deliver value to advertisers, sellers, and other corporate partners.
3. **Be good to shareholders** — When both users and business customers are trapped, extract every last cent for shareholders until the platform is a hollowed-out husk.

Sound familiar? It should, because literally every app and service you use has gone through this. But this isn't a post about Cory Doctorow's theory — this is about what I am *doing* about it.

## The LINE Messaging App: A Case Study in Enshittification

LINE launched in 2011 as a lightweight, fast messaging app born out of the chaos of the Tōhoku earthquake and tsunami, when people needed reliable communication. It had clean UI, stickers (obviously <i class="fa-regular fa-face-smile"></i>), and it just worked. It was particularly good for messaging in Japan and across East Asia.

Fast forward to 2026, and LINE is a monstrosity. The home tab has an AI chatbot *you cannot disable or remove*. There is LINE News, LINE Pay, LINE Crypto, LINE Shopping, LINE Games, LINE Music, ads injected everywhere, and a user interface so cluttered it feels like a shopping mall had a baby with a casino. They even removed the fourth tab bar item to make room for *more ads*. This is the textbook enshittification playbook — once LINE had captured enough users (step 1), it started extracting value through every possible vector (steps 2 and 3).

But here's the thing: underneath all that crap, **LINE's core messaging protocol still works fine**. The actual text messaging, stickers, image sharing — all of that is still there, buried under the bloat. Which means it can be salvaged.

## Unenshittification: The Concept

I've started using the term **"unenshittification"** to describe the process of reversing enshittification by rebuilding the *good parts* of a service while discarding everything else. The idea is simple:

- **Identify** what made the service good in the first place
- **Reverse engineer** the core protocol or data formats  
- **Rebuild** a clean, minimal client that does only what you need
- **Use AI** to dramatically accelerate steps 2 and 3

This is not about making a "better LINE" for the masses. It's about reclaiming the tool *for myself* — a tool that runs on *my* hardware, respects *my* privacy, and works exactly the way *I* want it to. And if it happens to work on the vintage hardware I love using, even better.

## ENIL: LINE, Backwards

Enter **ENIL** (LINE, backwards — clever, right? <i class="fa-solid fa-spoon"></i>).

ENIL is a reverse-engineered LINE client that I built from scratch. It implements the core LINE messaging protocol and provides a clean, native UI for:

- Sending and receiving text messages
- Sending and receiving stickers (obviously)
- Sending and receiving images
- Group chats
- Contact list management

What it does **not** include: ads, news feeds, crypto wallets, AI chatbots, shopping tabs, or any of the other garbage that LINE has accumulated over the years.

### Platform Support

ENIL is written in straight-up Cocoa and works on an absurdly wide range of Apple operating systems:

| Platform | Minimum Version | Notes |
|----------|----------------|--------|
| **macOS / OS X** | 10.4 Tiger | PowerPC and Intel |
| **iOS** | 4.3 | iPhone 3GS and newer |

Yes, you read that correctly. This thing runs on **OS X 10.4 Tiger** from 2005. It runs on an **iMac G4**. It runs on an **iPhone 5 with iOS 6** — which is exactly how I use it every day.

### Daily Driving It on an iPhone 5

[![ENIL on iPhone 5](/assets/images/retro-tech/enshittification-4/enil-chat-thumb.png)](/assets/images/retro-tech/enshittification-4/enil-chat.png){: .thumbnail }

I use ENIL as my daily LINE client on my iPhone 5 running iOS 6.1.3. It connects to LINE's servers, sends and receives messages, and participates in group chats just like the official app. My friends on modern LINE clients have no idea I'm messaging them from a 13-year-old phone running an OS that hasn't been supported since 2014.

The experience is *delightful*. The app launches instantly. Scrolling is buttery smooth. No ads. No "Trending News" section. No crypto wallet nag screen. Just messaging. The way it was supposed to be.

{: .continued }

And because I sync my iPhone 5 with my iMac G4 (as described in my [previous post about syncing iPhone 5 with PowerPC Macs](/retro-tech/2026/02/16/Reverse-iTunes-1.html)), everything fits into a coherent, vintage workflow that makes me genuinely happy to use.

## How AI Made This Possible

Here is where things get interesting. I have been a software developer for a long time — I've built apps, reverse-engineered things, and written plenty of code. But reverse-engineering a proprietary messaging protocol from scratch is a *massive* undertaking. It involves:

- Packet capture and analysis
- Decrypting TLS traffic (with proxy tools like mitmproxy)
- Reverse-engineering binary data formats
- Understanding undocumented API endpoints
- Implementing the protocol from scratch, handling edge cases
- Building a native UI for multiple platforms

In the past, this would have taken months or years of painstaking work. But with the help of AI — specifically large language models — I was able to do it in weeks.

### How I Use AI for Reverse Engineering

Let me be clear: AI did not do this for me. It cannot just "figure out" a proprietary protocol on its own. But what it *can* do is dramatically accelerate every step of the process:

**Packet Analysis.** When I captured network traffic between the official LINE app and LINE's servers, I could feed the hex dumps and parsed data structures to an LLM and ask: "What does this look like to you? Is this a length-prefixed message? Is this Thrift encoding? Is this a custom binary format?" The AI could pattern-match against known wire formats and give me strong hypotheses to investigate.

**Understanding Binary Formats.** LINE's protocol uses a custom binary encoding that is similar to, but not quite, [Apache Thrift](https://thrift.apache.org/). By feeding the AI sample binary data alongside Thrift documentation, I was able to iteratively decode the message structure without having to manually map every byte.

**Writing Parser Code.** Once I understood the binary format, AI helped me write the parser in Objective-C. I described what each field was supposed to be, and the AI generated the `NSData` category methods to decode them. I reviewed every line, but the speed increase was enormous.

**Generating Boilerplate.** LINE's protocol has dozens of message types. Manually writing the Objective-C model classes for each would have been soul-crushing. AI turned a tedious task into something almost pleasant.

**Debugging.** When messages failed to decode correctly, I could paste the hex dump, the expected output, and the actual output into an AI and say "why is byte 4 coming out wrong?" and get an immediate hypothesis about endianness or alignment issues.

**Cross-Platform UI.** Building the same UI twice — once for Mac (OS X 10.4, which means no ARC, no modern Objective-C features) and once for iOS 4.3 — meant writing a lot of similar-but-not-quite-the-same code. AI was excellent at adapting the Mac version to iOS conventions.

### The Human Element

This is the part that the AI hype machine gets wrong. AI did not *understand* what I was doing. It did not *design* the architecture. It did not *debug* the hard problems. All of that was me — my experience, my intuition, my willingness to spend hours in a hex editor or stepping through code in the debugger.

What AI did was eliminate the *friction*. It turned "I wonder if this is Thrift-encoded data" from a 3-hour research project into a 30-second conversation. It turned "I need to write 47 model classes" from a day of tedium into an hour of review. It turned "why is this byte wrong?" from a tear-your-hair-out debugging session into an immediate second pair of eyes.

The **taste**, the **judgment**, the **architectural decisions** — those are still human. And I suspect they will be for a long time.

## The Broader Vision: AI-Powered Unenshittification

ENIL is just one example. I am working on several more. The pattern is the same every time:

1. Pick a service that has been enshittified
2. Identify which parts of it I *actually* need
3. Reverse-engineer those parts (with AI assistance)
4. Build a minimal, clean client (with AI assistance)
5. Run it on my vintage hardware

This approach applies to everything. A YouTube client that just plays videos without algorithmic recommendations. A Twitter/X client that just shows your timeline in chronological order. An Instagram client that just shows photos from people you follow. The common thread is that AI makes it feasible for one person to reverse-engineer and rebuild these services — something that was previously only practical for teams of highly specialized engineers.

### Why Vintage Hardware Matters

You might wonder: why go through all this trouble just to run it on an iPhone 5 with iOS 6? Why not just build a modern macOS app?

The answer is that vintage hardware is part of the *philosophy*. Modern hardware is designed for planned obsolescence and constant upgrade cycles. Modern operating systems collect telemetry, serve ads, and treat the user as a resource to be extracted. By running my own software on vintage hardware, I am opting out of the entire ecosystem of enshittification.

My iPhone 5 doesn't have Siri. It doesn't have Apple Intelligence. It doesn't have a "For You" tab. It's just a phone — a tool that does exactly what I tell it to and nothing more. And the apps I build for it follow the same philosophy.

## What's Next

ENIL is working well for my daily use, but there's more to do:

- **Voice messages** — The protocol supports them, I just haven't implemented recording and playback yet
- **Video calls** — This is a stretch goal, the protocol is more complex
- **An ENIL icon** — Right now it just has a placeholder icon. I need to design something cute
- **Open source** — I want to release the code, but I need to make sure I'm not violating any laws by doing so (reverse engineering for personal use and publishing the results are two different legal questions)

I'm also working on similar projects for other services. YouTube might be next — wouldn't it be amazing to have a native YouTube app for Tiger and iOS 6?

## The Takeaway

Enshittification is real, and it is accelerating. Every platform you use will eventually get worse. But for the first time in history, the tools to fight back — to reverse-engineer, rebuild, and reclaim — are accessible to individual developers. AI dramatically lowers the barrier to entry for reverse engineering and protocol implementation.

You don't have to accept whatever garbage the platform owners shove at you. You can build your own. And if you have a soft spot for vintage Apple hardware like I do, you can build it to run on *those* machines too.

Now if you'll excuse me, I have some LINE messages to send from my 13-year-old phone <i class="fa-solid fa-mobile-retro"></i>
