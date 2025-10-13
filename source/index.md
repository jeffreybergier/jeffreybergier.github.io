---
layout: home
---

# Ongoing Projects
Choose the 
[{{ site.data.constants.apps.title }}]({{ site.data.constants.apps.url }}), 
[{{ site.data.constants.design.title }}]({{ site.data.constants.design.url }}), 
and [{{ site.data.constants.retro-tech.title }}]({{ site.data.constants.retro-tech.url }}) 
menu items to browse all articles, but to see more about my currently active
projects, use the links below \(Updated October 2025\)
- [iMac G4 Project Updates](https://jeffburg.social/tags/iMacG4){: target="_blank" }
- [Jekyll Website Development Progress](http://jeffburg.social/tags/iWeb){: target="_blank" }
- [MathEdit for OpenStep App Updates](http://jeffburg.social/tags/OpenStep){: target="_blank" }
- [iMac 5K Display Project Updates](http://jeffburg.social/tags/iMac5K){: target="_blank" }

# About Me
[![Jeff using a computer in the 90's](/assets/images/profile.jpeg)](/assets/images/profile.jpeg){: .reflect .below-xl .round-sm }
I’m a Quality Assurance Engineer and Team Lead in the automotive software
industry here in Tokyo. In a past life, I was an iOS and macOS developer and
teacher in San Francisco. In a past past life I earned my Bachelor of Science in
Industrial Design at San Francisco State University. 
{: .continued }

In my spare time I still enjoy working on Apps and I am very interested in Retro
Computing, specifically with old Macs, Mac OS X, and NeXTSTEP. I try to share
everything as much as possible on this site and on social media:
{: .continued }

<ul>
{% for link in site.minima.social_links %}
  <li>
    <a href="{{ link.url }}" target="_blank" rel="noopener">
      <i class="fab fa-{{ link.icon }}"></i>{{ link.title }}
    </a>
  </li>
{% endfor %}
</ul>

# Recent Articles