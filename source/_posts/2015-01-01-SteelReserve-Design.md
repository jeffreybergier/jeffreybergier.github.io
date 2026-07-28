---
layout: post
title: "SteelReserve Design"
titleAccessoryStyle: bleed
titleAccessory: "[![SteelReserve Design](/assets/images/design/steelreserve-design/srd-walkthrough-2k.png)](/assets/images/design/steelreserve-design/srd-walkthrough-2k.png)"
excerpt: "Reserving a conference room, at the last minute, shouldn't be hard."
categories: [Design]
tags: [Design, Professional]
---

## The Project
I think this has happened to everyone who has worked in corporate America. You're in a meeting with a bunch of people and the meeting goes over. Then another meeting needs the room you're in. So now your meeting needs to reserve a new room so everything can keep going. This usually involves someone opening their laptop, without a desk, and going through Outlook to try and find a room while everyone stands around aimlessly. SteelReserve was a design prototype I made to solve this problem. Later, I implemented this in Python and then again in server-side Swift. I learned a lot while doing the Swift version. I later gave a talk at a Swift meetup about what I learned.

### [Watch My Server-Side Swift Talk](https://web.archive.org/web/20190721152745/https://academy.realm.io/posts/slug-jeff-bergier-building-production-server-swift-app/){: target="_blank" }

---

### Storyboard
[![Storyboard](/assets/images/design/steelreserve-design/srd-storyboard-600.png)](/assets/images/design/steelreserve-design/srd-storyboard-2k.png){: .thumbnail }
Prototyping UI workflows in Xcode in Storyboards is fantastic. It's really fast, easy, and doesn't require code. Once a workflow is made in Storyboards, it's really easy to demo on device. It's also really easy to make videos to send around to people to sell them on the concept. Plus, any iOS developer could take the Xcode project and open it without needing a bunch of tools only designers have. Lastly, an iOS developer could reuse a lot of the work in an actual iOS App project.

### Primary Workflow
[![Primary Workflow](/assets/images/design/steelreserve-design/srd-mainflow-600.png)](/assets/images/design/steelreserve-design/srd-mainflow-2k.png){: .thumbnail }
This is the primary workflow of the app. On the first screen the user chooses how long they need the meeting to be. In step 2, they choose which office their group is in right now. In step 3, the user chooses which floor they are on. This is really more of a preference. If there are no rooms on their current floor, the app should find a room on other floors. Also, in this step, they choose how many people are in the group. The app needs this so it doesn't reserve a room that is too small. Lastly, the user is shown a confirmation screen, or an error screen if something went wrong. The confirmation screen tells them the final reservation details like the room and the floor. But it also includes the reservation beginning and end times. It also has a button to share the details with other people in the meeting.

### Extra Workflow
[![Extra Workflow](/assets/images/design/steelreserve-design/srd-extraflow-600.png)](/assets/images/design/steelreserve-design/srd-extraflow-2k.png){: .thumbnail }
I also added a prototype of how it might be possible to book a full meeting, in the future, with multiple participants. This flow would include the ability to see when they can meet. This was a nice idea, but so much more complex than the original idea. So only the primary workflow got turned into a full app.

### Final Result
[![Final Result](/assets/images/design/steelreserve-design/srd-walkthrough-1k.png)](/assets/images/design/steelreserve-design/srd-walkthrough-2k.png){: .thumbnail }
During a hackathon at work, a coworker and I implemented this app in Python using the CherryPy web server. It was super hacked together, but it worked! The flow was slightly different. Instead of the user choosing the size of the group and the floor they are on, the app displays a list of the rooms available for the time duration the user chose. This list separates the rooms by floor and also shows the size of the room. This change made it easier to implement. However, I like to think that people have their favorite rooms and now they can pick them every time, rather than the computer picking a random room.

SteelReserve makes it possible to easily see which rooms are available, right now, and pick one in less than 10 seconds. I later threw away the hacky Python I wrote and rebuilt it in server-side Swift. That took much longer because it was in my spare time and it was not hacked together. But it was worth it because SteelReserve still runs in production at work.
