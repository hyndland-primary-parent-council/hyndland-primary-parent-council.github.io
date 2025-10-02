---
layout: default
title: "Debug"
---

---
layout: default
title: "Debug"
---

<p>pages total: {{ site.pages | size }}</p>

{% assign news_pages = site.pages | where_exp: 'p', 'p.categories contains "News"' %}
<p>news pages (any date): {{ news_pages | size }}</p>

{% assign news_with_dates = news_pages | where_exp: 'p', 'p.date' %}
<p>news pages (with dates): {{ news_with_dates | size }}</p>

<ol>
  {% for p in news_pages limit:30 %}
    <li>{{ p.path }} — date: {{ p.date }} — <a href="{{ p.url | relative_url }}">{{ p.title }}</a></li>
  {% endfor %}
</ol>

