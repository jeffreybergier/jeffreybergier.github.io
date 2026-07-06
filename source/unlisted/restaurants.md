---
layout: page
title: レストラン
exclude: true
---

**目次**

{::options toc_levels="2,3" /}
* TOC
{:toc}

## おすすめ

{% include restaurants.html status="love" group_by="addressRegion" subgroup_by="addressLocality" sort_by="tabelog_score" sort_direction="descending" heading_prefix="###" show_cards=true %}

## 行きたい

{% include restaurants.html status="not_been" group_by="addressRegion" subgroup_by="addressLocality" sort_by="tabelog_score" sort_direction="descending" heading_prefix="###" show_cards=true %}

## もう行った

{% include restaurants.html status="have_been" group_by="addressRegion" subgroup_by="addressLocality" sort_by="tabelog_score" sort_direction="descending" heading_prefix="###" show_cards=true %}
