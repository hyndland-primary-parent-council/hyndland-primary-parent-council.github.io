---
layout: default
title: "Debug News"
permalink: /debug-news/
---

<p>site.news size: {{ site.news | size }}</p>

<ol>
{% for d in site.news limit: 10 %}
  <li>{{ d.path }} — {{ d.url }} — {{ d.title }} — {{ d.date }}</li>
{% endfor %}
</ol>


