---
layout: default
title: "News"
pagination:
  enabled: true
  per_page: 10
  items: "site.pages | where_exp:'p','p.is_news' | where_exp:'p','p.date' | sort:'date' | reverse"
---

{%- assign news_candidates = site.pages | where_exp: 'p', 'p.is_news' -%}
{%- assign news_with_dates = news_candidates | where_exp: 'p', 'p.date' -%}
{%- assign news = news_with_dates | sort: 'date' | reverse -%}

{%- if news.size == 0 -%}
  <p>No news items found.</p>
{%- else -%}
  {%- for p in news -%}
    <article class="post">
      <h2><a href="{{ p.url | relative_url }}">{{ p.title | escape }}</a></h2>
      <div class="meta">{{ p.date | date: "%B %-d, %Y" }}{% if p.author %} • {{ p.author }}{% endif %}</div>
    </article>
  {%- endfor -%}
{%- endif -%}
