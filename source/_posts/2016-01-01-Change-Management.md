---
layout: post
title: "Change Management Rapid Prototype"
titleAccessory: "[![Change Management](/assets/images/design/change-management/cm-visual-600.png)](/assets/images/design/change-management/cm-visual-2k.png){: .reflect .below-xl .round-sm }"
excerpt: "What if global network configuration was more like Git?"
categories: [Design]
tags: [Design, Professional]
---

## The Project
One of the main problems network operators have is managing change on their network. The problem is change commonly breaks things, so the established rule is to change as little as possible as rarely as possible. I wanted to try something better: where all changes can be seen, where approvals can be granted, and where accountability is clear.

---

### Change Timeline
[![Change Timeline](/assets/images/design/change-management/cm-now-600.png)](/assets/images/design/change-management/cm-now-2k.png){: .thumbnail }
Given a time period, the operator should be able to see when changes were saved in the system. They should also be able to see who made the changes and what changes were made. Also, depending on how the Role Based Management system works, changes might need to be submitted for approval before being put into effect. This is shown in the middle of this mockup.

### New Changes
[![New Changes](/assets/images/design/change-management/cm-newchanges-600.png)](/assets/images/design/change-management/cm-newchanges-2k.png){: .thumbnail }
Another really important feature of a change management system is rolling out changes to affected hardware. This does not happen instantly. It also needs to be scheduled as there are "maintenance windows" that can vary from location to location. In the mockup above, the time between starting a rollout to finishing it is shown in light gray. At the end, the operator would be able to click on that and get a status report on how the rollout went. Where did it fail and why?

### Summary of Changes
[![Summary of Changes](/assets/images/design/change-management/cm-changes-600.png)](/assets/images/design/change-management/cm-changes-2k.png){: .thumbnail }
This mockup and the previous one both show what it could look like when a different operator makes a change and it appears in the timeline for this operator to see. This operator can click on the event on the timeline to see what was changed. Depending on how Role Based Management is configured, an operator may need to approve the changes before a rollout can be started.

### Full Diff
[![Full Diff](/assets/images/design/change-management/cm-diff-600.png)](/assets/images/design/change-management/cm-diff-2k.png){: .thumbnail }
It may be necessary to dive deep into the changes made. This could be changes made in the past, or changes that have not yet been rolled out. This is a concept screen showing Application definition changes. This also features my favorite pet feature, impact. Impact shows the network admin approximately how many sites, users, etc this change will affect when it is rolled out.

### Pixel Perfect Mockup
[![Pixel Perfect Mockup](/assets/images/design/change-management/cm-visual-600.png)](/assets/images/design/change-management/cm-visual-2k.png){: .thumbnail }
All the mockups up to this point were done super quickly in Balsamiq. Rapid prototypes like this are not worth spending a lot of time on until you know the idea is worth investigating. After I made these basic mockups, the rest of the UX team thought it looked concrete enough to make a pixel perfect mockup. This mockup is the same timeline. I love seeing the transformation of a structural idea, into something that is just as useful, but also pleasing to the eye.
