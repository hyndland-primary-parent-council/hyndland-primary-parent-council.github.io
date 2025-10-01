---
layout: default
title: "Debug"
---
<p>pages total: {{ site.pages | size }}</p>
<p>news pages (any date): {{ site.pages | where_exp: "p", "p.is_news" | size }}</p>
<p>news pages (with dates): {{ site.pages | where_exp: "p", "p.is_news" | where_exp: "p","p.date" | size }}</p>
<ol>
{% for p in site.pages | where_exp: "p","p.is_news" | limit: 30 %}
  <li>{{ p.path }} — date: {{ p.date }}</li>
{% endfor %}
</ol>


