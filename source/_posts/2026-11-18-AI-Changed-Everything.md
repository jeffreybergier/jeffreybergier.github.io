---
layout: post
published: false
title: "AI Changed Everything"
categories: [Unenshittification]
---

## How it Started

In late 2025 I was still pre-AI. I mean, I knew AI existed and I had used it in 
chatbot form, but I had not yet tried any coding agents and overall, did not 
find it that useful. I mean, it was cool! Like, wow, its ability to parse random 
text and make sense of it was clearly a technical revolution.

In late 2025, when I decided 2026 would be the year I unenshittify my life, I 
therefore did not think AI would play a large part of it. But it was around 
January when I decided to try AI programming for real. It started slow. I was 
working on Altivec Intelligence in order to build my Docker container for retro 
Apple development. The AI was doing things I never knew how to do, building a 
build system. It was compiling complex new software projects like libcurl for 
retro Apple devices... and by compiling... I mean it was starting off huge 
builds that would fail, and then it would fix the issue and kick off the build 
again. It was by no means intelligent... But it was brute forcing and it was 
working. I was doing this with the free Google Gemini plan at the time.

In February, I decided to put some actual money into it. I signed up for 
Anthropic's $20 a month plan and started working on ENIL with Sonnet. The AI 
helped me do something else I had never tried before. It was taking the LINE 
Chrome extension, unmizing the JavaScript and we were figuring out how it 
worked together. 

We were partners in the whole development process: planning, prototyping, 
architecting, programming, and testing. It was a lot of fun and it sped 
everything up greatly. But I was still reading and understanding every line of 
code that came out of the machine. We were still working on bare minimum 
implementations to keep things moving forward quickly. And as a particular 
example of how cautious I was with the AI, I did not even let the agents run on 
my computer. I built all of the CLI's into the AltivecIntelligence Docker 
container. They all ran in a sandbox with YOLO mode on. The only things they 
could touch where folders that I explicitely added as Docker volumes.

## But Then it All Changed

Somewhere around May, I decided to switch to the $100 a month plan and see how 
much usage I could get out of Opus and to see if it would really kick things 
into gear.

It Did

After I finished ENIL, I decided that I was going to try something really 
experimental. I won't cover it all here because I covered it in the Strappy AI 
post. But I decided that I was going to build my own AI harness. Most AI 
harness projects you see out there are super simple because they rely on high 
level languages like Python and JavaScript. But if I was going to write a 
harness for retro devices, I would need to write it in C. To be clear, ENIL was 
also mostly written in C, but Strappy was going to be more complex than just 
making network requests. And I should also say that I am perfectly comfortable 
in Objective-C and I have done some basic C programming when needed in 
Objective-C, I am definitely not an expert.

This is when everything started to change. Yes, we were still partners in the 
whole development process and yes, Claude was still running in his Docker 
sandbox, but now I was merely the question asker. I stopped telling Claude what 
to do and simply started asking Claude what the best approach was for the 
problem I wanted to solve. I stopped reviewing the code line by line and 
started checking whether the "shape" (for lack of a better word) of the changes 
was right. I stopped going step by step with the AI. Instead, I would ask 
Claude how to implement a large change or feature and once we agreed on how to 
do it, I reply "make it so" and then work on a different app, different 
computer task, or just go make dinner, confident that when I came back, it 
would be done and it would work.

This is also around the time that I started providing test iPhones and Mac 
Virtual Machines online at all times with configured SSH keys for testing. I 
had previously relied on the AI doing all the tests on the pure C core which 
ran in Linux. And that is still the primary way of testing. However, for any 
UI work or end to end tests, the AI was able to now run the apps natively on 
the correct platforms, capture screenshots, and fix issues that arrived that 
were platform specific. It could also write automated UI tests that ran this 
way as well... mostly just dumb regression tests, but it works. At least 
nothing accidentally breaks. You have to keep in mind that this is all without 
Xcode, XCTest, or anything else that would normally be used in these 
situations. Those things simply did not exist in Mac OS X Tiger.

## And Now it is All Changing Again

After working on my own harness, I now know how insanely flexible the raw AI 
endpoint is. With relatively little structure, it can produce amazing insights 
from the data you give it. And what does this mean? I want to give an 
increasingly larger and larger amount of MY data to MY agent. I can pick the 
model, I can write the harness, and I can provide the data. And it is this last 
part where I am running into fundamental problems with the increasingly 
sandboxed world that Apple and Android users live in.

## TL;DR: What Changed (for me)

### Code is no longer for human consumption

Stop reading, stop writing, start validating. What matters is that the code 
does what you expected and with the performance characteristics you expected. 
Not that you have reviewed every single line of code yourself.

### High-level languages are no longer needed

This one is sort of a result of the previous one. But high-level languages 
like JavaScript, Perl, Python, Ruby, etc are meant to be easy to write and 
easy to read, but they do so at the expense of performance. Since no human is 
reading or writing the code any more, I think it is safe to say these languages 
have no practical benefits in production any more. They had already 
been "out of vogue" or whatever due to their lack of type safety. But now with 
AI, I really just don't know why you would give up so much performance.

### Your favorite language no longer matters

My first language was Objective-C and then Swift quickly thereafter. I love 
these languages. Before AI, I was excited when Swift would get a new sugar 
syntax or support on a new platform or new use case. But now with AI, none of 
this matters. Use the language that is most native to the use case and platform 
you are using. Don't try to shoehorn in the language you like. You won't be 
reading or writing the code anyway, so why not use the best supported or 
highest performance language that fits the use case at hand?

### Pretty code is slow code

Now that we don't need to read or write the code, we no longer need to simplify 
loop code. Yes, you can do `Array.filter.map.sort.foo.bar` OR you could do a 
for loop once and do all of that at the same time. The loop will be unreadable 
goop at the end, but it will be faster. And since we are not reading it any 
more, thats ok. Obviously loops are not the only place that performance 
suffers. But in general, tell the AI to focus on performance over readable code.

### Its OK to ask the AI

"Can you make clean and release and then run static analysis?" "What does this 
project do?" "On the Blah screen, how does the data flow between when the user 
pulls to refresh and when they see updated data in the tableview?" These are 
examples of questions I ask my AI all of the time. I have heard some argue that 
forfeiting this kind of basic knowledge to the AI somehow makes you a worse 
developer. I feel like this is like accusing a truck driver of being a worse 
driver because he can only drive an automatic. Its simply irrevelent to the goal 
of delivering goods on time.
