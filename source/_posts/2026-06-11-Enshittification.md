---
layout: post
title: "Enshittification"
titleAccessory: "<i class='apl-toolbar-aim-256 reflect below-md round-none'></i>"
excerpt: "Modern software rots from the inside out as companies extract every last cent. But with AI, we can fight back — here's how I reverse-engineered LINE Messenger into ENIL and run it daily on my iPhone 5 with iOS 6."
categories: [Retro-Tech]
tags: [Reverse-Engineer, iOS, PowerPC, Hobby, AI, Messaging]

---

* TOC
{:toc}

## What Is Enshittification?

Cory Doctorow coined the term [enshittification](https://pluralistic.net/2023/01/21/potemkin-ai/) to describe the lifecycle of online platforms. First, they're good to their users. Then they abuse their users to make things better for business customers. Finally, they abuse those business customers to claw back all the value for themselves. And then they die.

But here's the thing — enshittification is not just about platforms. It applies to **all software**. Every app you use, every service you depend on, is on this trajectory. Your favorite chat app? It's adding AI slop, crypto wallets, and a TikTok clone while the core messaging features rot. Your notes app? Now it's a "collaboration platform" with a subscription. Your music player? It's a social network now, for some reason.

I got tired of it. And thanks to AI, I finally have the tools to fight back
<i class="fa-solid fa-hand-fist"></i>

## The Old Way: You Just Had to Take It

Before AI, if a company enshittified their app, your options were:

1. **Suck it up** and keep using the worsening app
2. **Switch to a competitor** that would eventually enshittify too
3. **Stop using the service entirely** and lose touch with friends and family

None of these are good options. You're a passive consumer, and the companies know it. They count on your inertia. They know you won't leave because all your contacts are there, all your data is there, all your habits are there.

For years, this was just the way things were. I accepted it like everyone else. I grumbled when LINE added more tabs of garbage I didn't want. I rolled my eyes when the app got slower and more bloated with every update. But I kept using it because my friends in Japan were on it, and there was no alternative.

## The New Way: AI-Assisted Reverse Engineering

Then something changed. AI coding assistants got good. *Really* good. Not "write my whole app for me" good — that's still a fantasy — but "help me understand this protocol" good. "Generate the boilerplate while I focus on the hard parts" good. "Explain this disassembly I'm staring at" good.

Suddenly, reverse engineering a proprietary chat protocol and rewriting a compatible client went from "six months of full-time work" to "a fun weekend project with some follow-up."

AI didn't do the work *for* me. It couldn't. But it acted as a force multiplier. It helped me:

- Analyze network traffic and recognize protocol patterns
- Generate scaffolding code for the client architecture
- Debug cryptic error messages from the server
- Write parsers for proprietary message formats
- Navigate undocumented APIs without losing my mind

The key insight is that AI lowers the activation energy. What used to be daunting — "I have to reverse engineer an entire chat protocol?!" — becomes approachable. You still need to know what you're doing. You still need to understand the systems you're working with. But AI fills in the gaps, handles the tedious parts, and keeps you moving when you get stuck.

## ENIL: Reverse-Engineering LINE Messenger

LINE is the dominant messenger in Japan. It's what everyone uses. And it has been enshittifying for years. The app got heavier, the ads got more intrusive, and the basic chat functionality got buried under layers of junk features I never asked for.

So I reverse-engineered it.

I call the result **ENIL** — LINE, backwards. Because that's what it is: LINE turned inside out and stripped down to the parts that actually matter.

### What ENIL Does

ENIL connects to the LINE protocol and provides:

- One-on-one and group text messaging
- Sticker sending and receiving
- Image sharing
- Contact list syncing
- Push notifications (on supported OS versions)

That's it. No ads. No crypto wallet. No news feed. No AI chatbot. No "LINE Pay." No "LINE Today." No "LINE VOOM." Just messaging. The thing I actually wanted from a messenger.

### Where It Runs

ENIL targets the hardware I actually own and use:

| Platform | Minimum OS | Tested On |
|----------|-----------|-----------|
| macOS | OS X 10.4 Tiger | iMac G4 (PowerPC), MacBook (Intel) |
| iOS | iOS 4.3 | iPhone 4, iPhone 5 |

Yes, you read that right. **OS X 10.4 Tiger on PowerPC.** The operating system from 2005. And it works. It's not fast, but it works.

On iOS, ENIL runs beautifully on my iPhone 5 with iOS 6.1.3. The app is lightweight, responsive, and does exactly what I need it to do — nothing more, nothing less. My iPhone 5 has 1GB of RAM
<i class="fa-regular fa-face-surprise"></i>
and ENIL uses a tiny fraction of that. Meanwhile, the official LINE app on a modern iPhone chews through resources like there's no tomorrow.

### The Technical Approach

I built ENIL by watching the LINE protocol in action. The LINE client communicates with LINE's servers over a proprietary protocol layered on top of HTTPS and a persistent TCP connection. The messages are encoded in a binary format with some encryption layers.

Here's the rough process:

1. **Capture traffic** between the official LINE client and LINE's servers
2. **Identify the protocol layers** — authentication, encryption, message encoding
3. **Reimplement the client-side logic** in clean, minimal code targeting older OS versions
4. **Test against real servers** with a real account
5. **Ship it** and use it daily

The most challenging part was the authentication handshake. LINE uses a custom challenge-response mechanism tied to device fingerprints. But once I understood the flow, reimplementing it was straightforward — especially with AI helping me navigate the trickiest parts.

<div class="prompt-info" markdown="span">
**A Note on Ethics:** ENIL connects to LINE's servers using my own LINE account. I'm not stealing service, distributing malware, or enabling spam. I'm a paying user of LINE's service (via stickers and other purchases). ENIL is simply an alternative client — like using a third-party email client with Gmail. LINE's ToS may not love it, but I'm not hurting anyone. I just want to chat with my friends without the enshittification.
</div>

## My Daily Driver: iPhone 5 on iOS 6

I use ENIL every day on my iPhone 5 running iOS 6.1.3. This is not a retro computing novelty — this is my actual phone that I carry and use alongside my modern backup phone.

Why an iPhone 5 in 2026? A few reasons:

- **iOS 6 was the peak of iOS design.** It was fast, focused, and beautiful. Every update since has added complexity without adding value *for me*.
- **The iPhone 5 is the newest phone that runs iOS 6.** With 1GB of RAM and a 4-inch widescreen, it's perfectly usable.
- **Lightning connector.** I can charge it anywhere, even in 2026. Try finding a 30-pin cable these days.
- **5GHz WiFi.** Essential for decent network speeds.
- **It's small.** It fits in my pocket. I can use it one-handed. I miss that.

With ENIL on my iPhone 5, I can stay in touch with my friends in Japan using the same LINE service everyone else uses. They see my messages, I see theirs. They send stickers, I see them. Nobody knows I'm on a reverse-engineered client on a 14-year-old phone — and that's exactly how I want it.

## The Philosophy: Unenshittifying Your Life

ENIL is one piece of a larger project. I'm using AI to systematically unenshittify my digital life:

- **Messaging:** ENIL instead of the bloated LINE app
- **Music & Podcasts:** iTunes 10.6.3 on my iMac G4 synced with my iPhone 5 (after [defeating the version check](/retro-tech/2026/02/16/Reverse-iTunes-1.html))
- **Development:** Xcode 3.1 on PowerPC for [iPhone OS 3.1.3 development](/retro-tech/2025/12/04/PPC-iPhone-1.html)
- **Code signing:** [Custom tooling](/retro-tech/2025/12/09/PPC-iPhone-2.html) to sign apps for iOS 6 without a modern Mac

Each of these projects follows the same pattern: identify what the software actually needs to do, strip away everything else, and reimplement just the essential functionality. AI makes this feasible where it would have been impractical before.

This is not nostalgia. I'm not using old software because I'm sentimental about the past. I'm using old software because **new software is worse.** It's worse at the things I care about — speed, simplicity, focus, and respecting my attention. New software is better at extracting value from me, not at serving me.

## The Future: More Tools, More Freedom

AI is going to make this kind of thing easier and easier. We're entering an era where the asymmetry between software producers and software consumers starts to shrink. When anyone can reverse-engineer a protocol, reimplement a client, or patch out unwanted features, the power dynamic shifts.

Companies that enshittify their products will find their users leaving — not for competitors, but for self-built alternatives. The moat of proprietary protocols and closed ecosystems starts to drain.

I'm not saying everyone should become a reverse engineer. But I am saying that the barrier to entry has never been lower. If there's an app you use every day that's been getting worse and worse, maybe it's time to ask: *could I build my own?*

With AI, the answer might be yes.

## What's Next

ENIL is working well for daily use, but there's more I want to do:

- **Voice calls.** LINE supports VoIP calls. I'd like to add that to ENIL.
- **Group management.** Creating and managing groups works, but there are edge cases.
- **Better sticker rendering.** Some animated stickers don't display perfectly yet.
- **Maybe other protocols.** Why stop at LINE? There are plenty of enshittified messengers out there.

If any of this sounds interesting to you, or if you're working on similar projects, [find me on Mastodon](https://jeffburg.social/@Jeff). I'd love to hear about it. The more of us building our own tools, the less power the enshittifiers have.
