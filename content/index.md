---
layout: default
title: "Parent Noticeboard"
---

{% assign items = site.news %}

{%- if items.size == 0 -%}
  <p>No news items yet.</p>
{%- else -%}
  {%- for p in items limit: 10 -%}
    <article class="post">
      <header>
        <h2 style="margin:.25rem 0"><a href="{{ p.url | relative_url }}">{{ p.title | escape }}</a></h2>
        <div class="meta">{{ p.date | date: "%B %-d, %Y" }}{% if p.author %} • {{ p.author }}{% endif %}</div>
      </header>

      {%- assign paras = p.content | split: "\n\n" -%}
      {%- assign teaser = "" -%}
      {%- for para in paras -%}
        {%- assign t = para | strip -%}
        {%- assign first = t | slice: 0, 1 -%}
        {%- if t != "" and first != "[" and first != "#" -%}
          {%- assign teaser = t | strip_html -%}
          {%- break -%}
        {%- endif -%}
      {%- endfor -%}

      <div class="excerpt">{{ teaser | default: p.excerpt | default: p.content | strip_html | truncate: 200 }}</div>
    </article>
  {%- endfor -%}

  <p style="margin:1rem 0"><a href="{{ '/news/' | relative_url }}">Older paaaaosts →</a></p>
{%- endif -%}


