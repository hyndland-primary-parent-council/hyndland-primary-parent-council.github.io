---
layout: default
title: "Debug"
---

{% assign news_pages = site.pages | where_exp: 'p', 'p.categories contains "News"' %}
{% assign news_articles = news_pages | where_exp: 'p', 'p.extracted_mode == "article"' %}
{% assign news_with_dates = news_articles | where_exp: 'p', 'p.date' %}

<p>pages total: {{ site.pages | size }}</p>
<p>news pages (article mode): {{ news_articles | size }}</p>
<p>news pages (with dates): {{ news_with_dates | size }}</p>

<ol>
  {% for p in news_with_dates limit:30 %}
    <li>{{ p.path }} — date: {{ p.date }} — <a href="{{ p.url | relative_url }}">{{ p.title }}</a></li>
  {% endfor %}
</ol>


