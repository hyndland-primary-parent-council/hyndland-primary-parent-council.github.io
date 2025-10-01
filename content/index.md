---
layout: default
title: "Parent Noticeboard"
---

{%- assign news_candidates = site.pages | where_exp: 'p', 'p.is_news' -%}
{%- assign news_with_dates = news_candidates | where_exp: 'p', 'p.date' -%}
{%- assign news = news_with_dates | sort: 'date' | reverse -%}

{%- if news.size == 0 -%}
  <p>No news items yet.</p>
  <p style="color:#777;font-size:.9em">
    Debug: found {{ news_candidates.size }} pages under /news/ (with or without dates).
  </p>
{%- else -%}
  {%- for p in news limit: 10 -%}
    <article class="post">
      <header>
        <h2 style="margin:.25rem 0">
          <a href="{{ p.url | relative_url }}">{{ p.title | escape }}</a>
        </h2>
        <div class="meta">
          {{ p.date | date: "%B %-d, %Y" }}{% if p.author %} • {{ p.author }}{% endif %}
        </div>
      </header>
      {%- assign first_para = p.content | markdownify | strip | split:'</p>' | first | append:'</p>' -%}
      <div class="excerpt">{{ first_para }}</div>
    </article>
  {%- endfor -%}

  <p style="margin:1rem 0">
    <a href="{{ '/news/' | relative_url }}">Older posts →</a>
  </p>
{%- endif -%}
