---
layout: post
title: "Rule Icon System"
titleAccessory: "[![Rule Icon System](/assets/images/design/rule-icon-system/is-breakdown-600.png)](/assets/images/design/rule-icon-system/is-breakdown-2k.png){: .reflect .below-xl .round-sm }"
excerpt: "An at-a-glance view of all the rules that affect a user's global network."
categories: [Design]
tags: [Design, Professional]
---

## The Project
Network devices have many rules in them. Generally, these rules are painstakingly typed in via command line. They need to be deployed to every device on the network manually. If a rule that is shared on 1,000 devices needs to be changed, it needs to be changed 1,000 times. The goal with this project was to explore what a 'global' view of network rules would look like. Could a rule be made once and instantly applied everywhere? But more importantly, how could a network admin troubleshoot rules and see the effect of rules on their network?

### Author's Note
Normally, it's really scary to share Balsamiq mockups because they don't look refined. But I love this project because it highlights how visual hierarchy and white space are more important to an understandable design than really polished artwork. This icon system could be implemented in any design style and it would still work.

---

### Intent-Based Policy Rules
[![Intent Based Policy Rules](/assets/images/design/rule-icon-system/is-contents-600.png)](/assets/images/design/rule-icon-system/is-contents-2k.png){: .thumbnail }
These are a tiny number of slides from a large slide deck I put together. I was exploring "intent-based policy rules." The goal of these rules is to apply broad policy across a global network from a central management console. On this page, I'm focusing more on the visual system I designed for these rules, rather than the rules themselves.

### Visual Cues
[![Visual Cues](/assets/images/design/rule-icon-system/is-visuals-600.png)](/assets/images/design/rule-icon-system/is-visuals-2k.png){: .thumbnail }
This slide describes, in text, what the user is meant to see and how. Each rule has set icons for the various kinds of objects the rule can encompass. It also states that horizontal spacing is important. These icons should line up when rules are placed vertically on top of one another.

### Single Rule
[![Single Rule](/assets/images/design/rule-icon-system/is-breakdown-600.png)](/assets/images/design/rule-icon-system/is-breakdown-2k.png){: .thumbnail }
Three slides that go through every possible icon that can be on every rule and explain what they all represent. I think the coolest part of each rule is the success indicator on the bottom. Network admins tell us over and over that "right now" status is useless to them. They need to see the status of everything over time.

### Rules Table
[![Rules Table](/assets/images/design/rule-icon-system/is-list-600.png)](/assets/images/design/rule-icon-system/is-list-2k.png){: .thumbnail }
This is the rules table where all the rules get stacked together. This slide attempts to highlight the importance of the vertical alignment. Because the icons are always aligned, it is really easy to glance through the rules and see which rules affect which parts of the network and what kind of actions the rules are performing on the network. Also, because of the "success" indicator, it is easy to see which rules are doing well and when.

### Impact
[![Impact](/assets/images/design/rule-icon-system/is-impact-600.png)](/assets/images/design/rule-icon-system/is-impact-2k.png){: .thumbnail }
Rules can affect Sites, Users, and Applications. However, not all rules affect all of those things and even if they do, they may affect 1 user or 10,000 users. Impact is a concept that attempts to quantify how many of each of these subjects are affected by a rule. It also shows how that changes over time. This is incredibly useful for what network administrators call "change management." If a rule only affects 10 users, it's easy to change or delete. If a rule affects 10,000 users, more work needs to be done before changing it.

### QoS Action
[![QoS Action](/assets/images/design/rule-icon-system/is-qos-600.png)](/assets/images/design/rule-icon-system/is-qos-2k.png){: .thumbnail }
Each rule can have one of many actions applied to it. QoS is one of those actions; it's also my [party trick]({% post_url 2014-01-01-QoS %}) because I've spent so much time on it. This slide shows how QoS can be applied in a rule.
