---
layout: post
title: "QoS Redesign"
titleAccessory: "[![WaterMe Icon](/assets/images/design/qos/profiles-600.png)](/assets/images/design/qos/profiles-2k.png){: .reflect .below-xl .round-sm }"
excerpt: |
  Redesign QoS on SteelHead and SteelCentral Controller so network admins could
  manage traffic with more power, less pain, and fewer tiny configuration crimes.
categories: [Design]
tags: [Design, Professional]
---

## Project

SteelHead QoS was being rebuilt, which meant the design could finally stop
pretending the old model was cute. It was powerful, yes. Understandable? Mmm,
let's not lie in public.

QoS is a lot: bandwidth, latency, classes, DPI, priorities, network topology,
failure states, and the brutal truth that giving one thing more priority means
taking it from something else. There is no magic bandwidth purse, darling.

So we did the work. We researched the feature, interviewed real network admins,
mapped the mess, and designed a cleaner mental model for managing QoS across
SteelHead and SteelCentral Controller.

* TOC
{:toc}

### Feature Research

[![Screenshot](/assets/images/design/qos/feature-600.png)](/assets/images/design/qos/feature-2k.png){: .thumbnail }

First, I had to understand the beast. HFSC, QoS classes, deep packet inspection,
latency priority, minimum bandwidth, maximum bandwidth. The whole technical
pageant.

I got deep enough that some engineering questions could not be answered from
memory. People had to go read the source code. That is when you know the design
research has arrived wearing boots.

### User Research

[![Screenshot](/assets/images/design/qos/user-600.png)](/assets/images/design/qos/user-2k.png){: .thumbnail }

After learning how QoS worked internally, we talked to the people actually
responsible for making it behave: network administrators.

I went onsite in Illinois, Montreal, and the UK, and worked with a researcher on
remote interviews with more firms. We learned what admins used QoS for, where
the current product made them suffer, and what they needed next.

The answer was not "give me 900 more settings and a migraine." They wanted
control, confidence, and a model that matched how their networks actually worked.

### Sites

[![Screenshot](/assets/images/design/qos/sites-600.png)](/assets/images/design/qos/sites-2k.png){: .thumbnail }

QoS needs to know the speed of every network connection so it can divide
resources intelligently. Simple sentence. Extremely rude problem.

Customers can have hundreds or thousands of locations, and each location can
have multiple uplinks. So I created the concept of **Sites**.

A site contained uplinks. Each uplink had upstream and downstream bandwidth.
Clean. Concrete. No spreadsheet séance required.

This gave QoS the bandwidth constraints it needed while giving admins a model
that matched the way they already thought about their network.

### Classes

[![Screenshot](/assets/images/design/qos/classes-600.png)](/assets/images/design/qos/classes-2k.png){: .thumbnail }

QoS classes are buckets for traffic. Put applications into a class, then tell
the system how important that class is.

But priority is not a tiara everyone gets to wear. If one class gets more
resources, another gets less. And if every app is marked critical, then nothing
is critical. Congratulations, you made a very expensive shrug.

Admins understood this tension, but the UI needed to help them see it. I explored
ways to visualize those tradeoffs and show class behavior more clearly. The
final direction used a simpler tree visualization because sometimes the best
design is the one that does not make users file a support ticket with their
therapist.

### Rules

[![Screenshot](/assets/images/design/qos/classes-600.png)](/assets/images/design/qos/classes-2k.png){: .thumbnail }

Rules are how admins put applications into QoS classes.

Because SteelHead had strong deep packet inspection, admins could search for
applications by name instead of lovingly handcrafting IP and port mappings like
it was 2003 and nobody had feelings.

We also grouped applications into about eight larger categories, each with
hundreds of apps. Rules could target a single app or a whole app group, which
made configuration much faster and much less cursed.

### Profiles

[![Screenshot](/assets/images/design/qos/profiles-600.png)](/assets/images/design/qos/profiles-2k.png){: .thumbnail }

Profiles connected Sites, Classes, and Rules.

SteelCentral Controller had a network-wide view of all the SteelHeads in a
customer environment, so we used that knowledge. Admins could choose source and
destination sites, or groups of sites, and define the QoS behavior for that
relationship.

Then SteelCentral Controller could distribute the right profiles to the right
appliances automatically. Imagine that: the computer doing the computer work.

This moved QoS toward intent-based management. Admins specified **what** they
wanted, and the system handled more of **how** to make it happen. Less manual
wiring. More strategy. Very correct.

## Experimentation

Not every concept ships. Some ideas are unnecessary. Some are too complex. Some
are gorgeous little divas that need to leave the stage.

These are a few explorations that did not make it into the product.

### QoS Class Feedback

[![Screenshot](/assets/images/design/qos/profile-experiment1-600.png)](/assets/images/design/qos/profile-experiment1-2k.png){: .thumbnail }

Setting minimum and maximum bandwidth for a QoS class can become a guessing
game: pick numbers, wait, squint at the results, repeat until morale improves.

I explored designs that warned admins about class issues and summarized
congestion over time. The goal was to make QoS less mysterious and help admins
catch bad configurations before production started sending smoke signals.

### Uplink Variations

[![Screenshot](/assets/images/design/qos/profile-experiment2-600.png)](/assets/images/design/qos/profile-experiment2-2k.png){: .thumbnail }

Uplink variations let admins define different class allocations depending on
which uplink was active.

That matters when connections fail. In a degraded state, critical traffic may
need different treatment than it gets during normal operation. This concept let
admins design for reality instead of pretending the network would always behave.
Adorable fantasy, but no.

### Dashboard Widget

[![Screenshot](/assets/images/design/qos/dashboard-experiment-600.png)](/assets/images/design/qos/dashboard-experiment-2k.png){: .thumbnail }

SteelCentral Controller already had strong dashboards, so I explored what a QoS
widget could look like.

The widget showed QoS classes at a glance. Expanding a class revealed relevant
errors and warnings, giving admins a fast way to see where policy or performance
needed attention.

Because if something is on fire, the UI should say so clearly. Preferably before
everyone is in a conference room pretending this was unforeseeable.