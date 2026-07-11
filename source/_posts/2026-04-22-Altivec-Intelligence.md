---
layout: post
title: "Altivec Intelligence"
titleAccessoryStyle: wide
titleAccessory: "[![Altivec Intelligence title artwork](/assets/images/unenshittification/altivec-intelligence/altivec-intelligence-thumb.png)](/assets/images/unenshittification/altivec-intelligence/altivec-intelligence-full.png){: .reflect .below-xl .round-sm }"
excerpt: |
  Build small, personal apps for decades of Apple hardware without Xcode,
  Mac virtual machines, or permission from a platform owner
categories: [Unenshittification]
tags: [Apple, Retro-Tech, Objective-C, Mac-OS-X, iOS, Docker, AI]
---

## Lessons Learned

In 2024 I developed MathEdit for OpenStep. This app was a proof of concept to
see if I could develop a Cocoa application for OpenStep and then upgrade it to
work on every version of Mac OS X. The application was a success, but even
though it was a simple app, it took me exactly 1 year of spare time programming
to develop and then to upgrade through 20 years of Mac OS X history. The
primary reasons for this were that Objective-C from 1996 was pretty painful to
write plus, I was writing it all in real OpenStep and vintage Mac OS X virtual
machines with ancient tooling.

In the age of AI, this solution was not going to suit me any more. I needed
a modern environment that could run on any computer and still create apps for my
favorite retro platforms. I needed this platform to support AI because it
reduces the pain of writing Objective-C 1.0 code that lacks:

- Automatic Reference Counting
- Fucking Block Syntax
- Property Syntax
- Dot Syntax
- Grand Central Dispatch
- Collection Literals

## Altivec Intelligence

Altivec Intelligence is all in one integrated development docker container
that has everything I need to develop Cocoa and Cocoa Touch applications that
run on [PowerPC Macs](/retro-tech/) with Mac OS X Tiger or later and iPhones
running iOS 4.3 and later. And before you ask, yes, the Mac apps are universal binaries with 4
slices: PowerPC, x86, x64, and arm64 😎

On top of that Altivec Intelligence includes tooling for web development,
image manipulation, and ffmpeg plus the most important part: All of the AI
agent CLIs are baked into the container.

Why is this important? Well, these agents are incredibly powerful and helping
me to [unenshittify my life]({% post_url 2026-02-22-Unenshittification-101 %}).
But they cannot be sandboxed and cannot be trusted as long as they bash access.
By running them in a Docker container I can safely
run them in YOLO mode with no risk to my own Mac. They have all the tools they
need to create great apps all without ever changing my development environment
or editing files outside of my repositories.

## Libraries

A modern retro toolchain wouldn't be complete without modern libraries to help
these retro system do modern tasks. Altivec Intelligence includes critical 
libraries bundled into Dynamic Frameworks and Static Libraries.

- AltivecCocoa: Includes FontAwesome and other helper classes that make it easy to build applications that run across 20+ years of Apple history
- AltivecCore: Includes modern networking and database tooling to interact with modern web APIs
   - SQLite 3.43.2
   - libcurl 7.88.1
   - OpenSSL 1.1.1w
   - zlib 1.2.13
   - cJSON 1.7.19

## Tooling

I will not go into all the details because you can view that on GitHub. But
Altivec Intelligence includes a lot of basic tooling to make it easy to 
build, deploy, and debug apps to [retro devices](/retro-tech/). This all relies on SSH key
authentication which can also be customized because the container mounts the 
home folder in ~/.altivec. This way you can always control which keys the 
container (and the agents) have access to. `altivec-deploy` is an included
script that can deploy your apps to Macs and to
jailbroken iPhones to start
[debugging sessions with GDB]({% post_url 2025-12-09-PPC-iPhone-2 %}) or LLDB.
`altivec-release` automatically bumps
the versions of the apps in the Info.plist files.

## Caveats

Altivec Intelligence is offered as a prebuilt Docker container for arm64 and x64
devices. It supports arm64 and x86-64 computers capable of running Docker.

It does not include Apple proprietary tooling so there is no support for NIBs
for example. Deploying to an iPhone requires a jailbroken iPhone with SSH
installed. Supporting Mac OS X Tiger requires using a lowest common denominator
of Mac OS X API's. The AI will help you do the runtime introspection, but it
can be a pain.

For usage instructions and example apps, see the project on GitHub.

[https://github.com/jeffreybergier/AltivecIntelligence](https://github.com/jeffreybergier/AltivecIntelligence)
