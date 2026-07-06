---
layout: post
title: "Let the Glue Code Be Ugly"
titleAccessory: "<i class='apl-trash-cocoa-256 reflect below-sm round-none'></i>"
excerpt: "AI coding assistants changed what I value in personal software projects: not beautiful glue code, but fast, reliable, well-tested software with clear boundaries."
categories: [Unenshittification]
tags: [AI, Programming, C, Objective-C, SQLite, Performance]
---

I have been using AI coding assistants heavily for about six months now, mostly
on personal side projects. That distinction matters. I am not a software
developer at work. I am helping introduce AI workflows into my team, but most of
that work is for non-programming tasks. My programming experience with AI is
almost entirely in the context of small personal apps, tools, experiments, and
old-computer projects.

Those projects are exactly the kind of thing I would have written by hand in the
past, but much more simply. I would have kept the scope small because I knew
how much work the boring parts would be. Networking. Parsing. Persistence. Build
scripts. Deployment scripts. Little compatibility shims. Error handling. Data
conversion. All the glue.

AI has completely changed how I think about that work.

## The Old Bargain

Before AI, I was in the same boat as most Apple-platform developers. Or really,
pick your preferred vendor, language, or framework community. I liked new
language features. I liked new frameworks. I liked things that made programming
feel cleaner.

Less code was good. More things happening automatically was good. A better
abstraction was good.

I remember being excited about SwiftUI because, in theory, I would never need to
write another `UITableViewDataSource` or `UITableViewDelegate` method again.
That still sounds great. A SwiftUI `List` is so much nicer to write than the
old UIKit table-view ceremony.

But there is a tradeoff. Those nicer abstractions often come with real
performance costs. Sometimes they are worth it. Sometimes they are not. Either
way, the tradeoff gets hidden under the beauty of the API.

The same thing happens with architecture. When code is written by hand, it needs
to be understandable by hand. It needs structure. It needs boundaries. It needs
patterns that let a human keep the whole system in their head.

That is why abstractions are so seductive. Reactive programming can make data
flow easier to reason about. Functional chains like `map`, `filter`, and `sort`
can make transformations beautiful and readable. But sometimes the beautiful
version walks the same array three or four times when a boring loop could have
done the work once.

For hand-written code, I used to accept that tradeoff all the time. I wanted the
code to be pleasant. I wanted to understand it. I wanted it to look like
something I would be proud to maintain.

AI changed the bargain.

## I Do Not Need the Glue Code to Be Beautiful

Now I want something different from a lot of my code.

I want the AI to write code I would refuse to write by hand.

I want it to take the clean, convenient, abstract version and explode it into
the ugly, explicit, purpose-built version that is faster, more compatible, and
less dependent on magic. I want the boring loop. I want the manual error path. I
want the tedious compatibility branch. I want the generated code that is too
verbose for me to enjoy writing, but direct enough for the computer to run
quickly.

That sounds like a regression if the goal is beautiful source code. But that is
not always my goal anymore.

For these projects, the thing I care about is the experience. Does it launch
fast? Does it scroll smoothly? Does it survive bad input? Does it keep working
on old hardware? Does it store the right data? Does it recover cleanly? Does it
feel polished?

If the answer is yes, I care much less whether the implementation is elegant.

This is how I ended up turning into a character from an old WWDC joke: "I do not
need an IDE. I do not need a GUI." I now build my personal iOS and macOS apps
with Makefiles. I deploy them to devices with shell scripts and `ssh`. I build
releases in GitHub Actions without Xcode, without macOS runners, and without
Mac VMs. Just plain Ubuntu containers doing boring, direct work.

Instead of wrapping everything in Apple-flavored abstractions, I use things like
`libcurl` and SQLite directly. The UI is still UIKit or AppKit, because that is
where the platform experience lives. But networking and persistence can stay in
C until the moment the UI needs data.

At first, I assumed I would need Objective-C wrappers around the C parts. A
little wrapper around `libcurl` that behaved like `NSURLConnection`. A little
wrapper around SQLite that behaved like a tiny Core Data.

Then I asked a coding assistant to help me think it through, and the answer was
basically: the networking is in C, and the database is in C, so why put
Objective-C in the middle?

That was the point where the whole thing clicked.

## House Rules Instead of Pretty Code

Letting AI write ugly code does not mean letting it write anything it wants.

The difference is that I now care more about rules than aesthetics. I put the
rules in `AGENTS.md`, repeat them in prompts, and grill the agent after a
feature is working.

Some examples:

- The SQLite database is the source of truth for the UI.
- Only one C file is allowed to touch Cocoa APIs.
- Only one Objective-C file is allowed to import the C headers.
- The compiler must produce zero warnings.
- Clang Static Analyzer must produce zero warnings.
- Data flow must be explainable after the feature is implemented.

These rules create a shape for the system without requiring every line to be
lovely. I do not need the generated C code to read like a textbook. I need to
know where state lives. I need to know which file owns which responsibility. I
need the compiler and static analyzer to be quiet. I need enough tests and
manual verification to trust the behavior.

After a feature works, I usually spend a few prompts interrogating the
implementation. What is the source of truth? How does data flow from the network
to the database to the UI? Where are errors handled? What happens if the request
fails halfway through? Is this actually abstracted where it needs to be, or did
we just create ceremony?

That last question matters. I do not want architecture for decoration. I want
boundaries that make the system easier to control.

The resulting code is often not something I would call maintainable in the
traditional human sense. It can be verbose. It can be repetitive. It can be
purpose-built. It can contain tens of thousands of lines of C that I would
never have written manually.

But it is also some of the most performant and reliable code I have ever
"written."

## The Slop Apps Do Not Crash

I know "AI slop" is supposed to be an insult, and often it should be. But I have
started using the word differently for my own projects. These are slop apps in
the sense that the code is not precious. It is generated, revised, replaced,
tested, and thrown around.

The surprising part is that they do not crash.

They have bugs. Of course they have bugs. But they do not crash in the way my
hand-written hobby apps used to crash. They are fast. They are direct. They are
full of explicit checks. They do not rely on giant layers of runtime magic. When
performance issues do appear, I describe the behavior to the assistant, gather
logs or database state, and work through it.

Most of the time, performance is not the problem.

That is new for me. In the past, I would often avoid polish because polish made
the code worse. A better animation meant another state machine. A nicer UI meant
more edge cases. More compatibility meant more tedious branches. At some point I
would decide the code was already complicated enough, and the user experience
would stop improving.

Now I am much more willing to add the polish. More animation. Better empty
states. Better loading states. Better synchronization behavior. Better tooling.
It is all just more generated code, and generated code is no longer something I
feel the need to keep beautiful.

That is a strange mental shift.

## The Important Boundary: This Is Glue Code

I am not saying AI should write everything. I am not talking about kernel work,
cryptography, a database engine, a compiler, a safety-critical control system,
or anything else where the hard part is deep technical correctness.

I am talking about glue code.

Most of the code in most apps is glue code. It takes data in one format and
converts it into another. It fetches JSON from a server, validates it, stores it
in a database, and displays it in a UI. It checks whether a user is allowed to
see or change something. It synchronizes local state with remote state. It turns
database rows into screen models. It turns screen actions back into database
updates or network requests.

That is not magic. It is important, but it is not special in the way we often
pretend it is special.

Backend code is often the same story. Yes, scaling to large numbers of
simultaneous requests is hard. Yes, propagating data correctly across regions is
hard. Yes, operations, observability, and failure modes matter. But a huge
amount of everyday backend work is still moving data between formats and
checking permissions before responding.

This is exactly where AI is useful. Writing this kind of code by hand can be
soul-sucking. The only fun part used to be inventing abstractions to reduce the
boilerplate. But if the assistant can generate the boilerplate, maybe I do not
need the clever abstraction. Maybe the boring explicit version is better.

That does not mean "never abstract." It means the abstraction has to earn its
place. If it exists only because I do not want to type repetitive glue code
myself, AI has changed the economics.

## Do Not Review Slop Like Literature

One of the worst AI workflows, in my opinion, is asking a human developer to
review giant piles of generated code line by line as if it were hand-written
craft.

That is exhausting, and it misses the point.

Generated glue code should be reviewed differently. I care less about whether a
function is pretty and more about whether the behavior is constrained. Are there
tests? Does static analysis pass? Are warnings treated as failures? Is the data
model clear? Are side effects contained? Can the agent explain the data flow?
Can I reproduce the bug? Can I inspect the database directly? Can I verify the
result on the real device?

The human should spend more time testing the generated code than admiring or
despising it.

This is another place where AI has been useful beyond writing code. I paste in
logs. I have the assistant write diagnostic scripts. I have it inspect SQLite
databases. I have it `ssh` into old devices, copy database files out, and
compare what the app thinks happened with what actually got stored.

That ability changed how I think about tools too. If an assistant is good at
diving into raw SQLite databases and summarizing what it finds, maybe I do not
need a perfect abstraction layer for every kind of personal data. Maybe I can
build tools that expose the raw material clearly and let the assistant help me
work with it.

## The Emotional Part

I understand why a lot of programmers dislike this.

If programming feels like authorship, AI can make the work feel like middle
management. Instead of writing the paragraph, you are assigning the paragraph,
checking the paragraph, correcting the paragraph, and wondering why this is
supposed to feel creative.

That feeling is real.

What I have found is that AI shifts the source of enjoyment. If the joy came
from making the code beautiful, AI can take that away. If the joy comes from
the thing being built, AI can be liberating.

This is why the work itself matters more now. If I am not interested in the app,
service, tool, or experience, then corralling an LLM is not satisfying. There is
no beautiful abstraction to rescue the day. There is only the product and
whether I care about making it better.

For personal projects, I do care. I care about making old devices useful. I care
about replacing services I dislike. I care about fast apps. I care about being
able to build and deploy things outside the polished cage of vendor tooling. So
AI has made programming more fun for me, not less.

But I can easily imagine the opposite experience at work. Being forced to use AI
on something you do not care about, under policies you did not choose, while
reviewing code you do not respect, sounds miserable.

## The Industry Part

I also think some of the anxiety is justified.

If the golden age of engineering means getting paid enormous salaries to write
basic glue code while dressing it up as deep framework work, then maybe that
golden age really is ending.

That sounds harsh, but I include myself in the criticism. A lot of app code is
not as profound as we sometimes make it sound. Much of it is JSON in, database
out, permissions checked, UI updated. AI is very good at that shape of work.
It is fast, cheap, tireless, and often willing to write the ugly high-performance
version that a human would avoid.

I do not think that means the next generation of developers will not exist. I
think they are already using these tools for everything and moving faster than
we expect. The fear that they will not learn "real programming" reminds me a
little of worrying that people will not be able to fix their own cars anymore.
Some people still will. Most people will interact with the machinery at a
different level.

The level is moving.

That is uncomfortable, but it is not automatically bad.

## Letting the Computer Stretch

The biggest change for me is that I no longer feel the need to make every line
of code something I would have enjoyed writing.

That has opened up a lot.

I can write apps with Makefiles. I can use C directly. I can support old systems
without creating some grand compatibility abstraction. I can generate shell
scripts, Python scripts, Node servers, build pipelines, release tooling, and
database inspection tools without treating each one like a separate hobby. I can
ask for the tedious version, the verbose version, the fast version.

The result is not beautiful code.

The result is software I would not have had the patience to build before.

For a long time, I accepted slow code or missing polish because the better
version would have been too ugly to maintain. AI changed that. It lets me make
the computer stretch its legs by generating basic, verbose, direct code that is
fast enough and full-featured enough to make the experience better.

I still like programming by hand. I still like beautiful code. I still think
clear abstractions matter when humans have to live in the codebase every day.

But for a lot of personal glue code, I am learning to let go.

The code can be ugly.

The app should be good.
