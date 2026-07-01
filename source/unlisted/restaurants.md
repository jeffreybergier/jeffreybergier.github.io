---
layout: page
title: レストラン
exclude: true
---

[元データ](/unlisted/restaurants-import.html)

**目次**

{::options toc_levels="2,3,4" /}
* TOC
{:toc}

## おすすめ

{% include restaurants.html status="love" group_by="area" sort_by="tabelog_score" sort_direction="descending" heading_prefix="###" show_cards=true %}

## 行きたい

{% include restaurants.html status="not_been" group_by="area" sort_by="tabelog_score" sort_direction="descending" heading_prefix="###" %}

## 全て

{% include restaurants.html group_by="area" sort_by="tabelog_score" sort_direction="descending" heading_prefix="###" %}
