---
layout: post
published: false
title: "How AI Changed Me"
titleAccessory: "<i class='apl-trash-cocoa-256 reflect below-sm round-none'></i>"
excerpt: "AI coding assistants changed what I value in personal software projects: not beautiful glue code, but fast, reliable, well-tested software with clear boundaries."
categories: [Unenshittification]
tags: [AI, Programming, C, Objective-C, SQLite, Performance]
---

## Outline

1. **Personal Context**
   - Six months of heavy AI coding-assistant use
   - Mostly personal apps, tools, experiments, and old-computer projects
   - AI makes projects possible that would otherwise be too tedious or too
     limited in scope

1. **The Old Bargain**
   - Hand-written code rewards concise syntax, clean abstractions, and code a
     human can keep in their head
   - Convenient frameworks hide performance and compatibility costs
   - Examples: SwiftUI versus UIKit; functional chains versus one boring loop

1. **Ugly Glue Code Is Fine**
   - AI can write explicit, repetitive, purpose-built code that I would not
     enjoy writing by hand
   - Prefer direct loops, manual error paths, and compatibility branches when
     they improve the product
   - Judge the app by speed, reliability, polish, and old-hardware support—not
     source-code beauty

1. **Simpler, More Direct Tools**
   - Makefiles instead of Xcode projects
   - Shell scripts and SSH for deployment
   - GitHub Actions and Ubuntu containers for releases
   - C libraries such as libcurl and SQLite beneath native AppKit/UIKit UIs
   - Avoid Objective-C wrappers when the network and database layers can
     communicate directly in C

1. **House Rules Instead of Pretty Code**
   - Put architectural and compatibility rules in `AGENTS.md`
   - SQLite is the source of truth for the UI
   - Strict boundaries between C and Cocoa
   - Zero compiler and static-analyzer warnings
   - Data flow and ownership must remain explainable
   - Interrogate the implementation after it works

1. **The Slop Apps Do Not Crash**
   - Generated code is not precious; revise, replace, and test it freely
   - Explicit checks and fewer layers of runtime magic improve reliability
   - AI makes tedious polish affordable: animations, empty states, loading
     states, synchronization, compatibility, and tooling
   - The resulting apps are often faster and more reliable than my old hobby
     apps

1. **The Boundary Is Glue Code**
   - This argument is about ordinary application glue, not kernels,
     cryptography, compilers, database engines, or safety-critical systems
   - Most app code moves data between APIs, databases, models, and UIs
   - AI changes the economics of boilerplate
   - Abstractions should earn their place instead of existing only to reduce
     typing

1. **Review Behavior, Not Literature**
   - Do not review huge amounts of generated code as if it were handcrafted
     prose
   - Focus on tests, warnings, static analysis, state, side effects, boundaries,
     reproducibility, and real-device behavior
   - Use AI to inspect logs, SQLite databases, device state, and failures
   - Spend more time testing generated code than admiring or despising it

1. **The Emotional Shift**
   - AI can make programming feel like management instead of authorship
   - If the joy is beautiful code, AI may reduce it
   - If the joy is the finished product, AI can be liberating
   - Personal projects remain satisfying because I care about the experience
     being built
   - Forced AI use on uninteresting work could feel miserable

1. **The Industry Shift**
   - Much well-paid application work is ordinary glue code presented as deeper
     framework work
   - AI is particularly effective at JSON, databases, permissions, and UI state
   - The next generation will interact with programming at a different level
   - The level is moving; that is uncomfortable but not automatically bad

1. **Letting the Computer Stretch**
   - Generate compatibility code, scripts, servers, build pipelines, release
     tools, and diagnostics without making each one its own project
   - Stop accepting slow code or missing polish merely to keep implementation
     elegant
   - Continue valuing beautiful code where humans must maintain it closely
   - For personal glue code: the code can be ugly; the app should be good
