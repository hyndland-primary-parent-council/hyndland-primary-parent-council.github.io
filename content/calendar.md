---
title: Calendar
layout: default
permalink: /calendar/
---

<div class="mb-4">
  <h1 class="h2 fw-bold mb-2">Calendar</h1>
  <p class="text-muted mb-0">Browse all dates in one place. Subscribe once and any additions or updates will appear on your device.</p>
</div>

<!-- Subscribe buttons -->
<div class="d-flex gap-2 flex-wrap mb-4">
  <!-- Google Calendar -->
  <a href="https://calendar.google.com/calendar/embed?src=hppcshared%40gmail.com&ctz=Europe%2FLondon"
     target="_blank"
     class="btn btn-danger rounded-pill d-flex align-items-center gap-1"
     title="Google Calendar"
     aria-label="Open Google Calendar to subscribe">
    <i class="bi bi-google"></i>
    Google Calendar
  </a>

  <!-- Apple Calendar -->
  <a href="webcal://calendar.google.com/calendar/ical/hppcshared%40gmail.com/public/basic.ics"
     class="btn btn-primary rounded-pill d-flex align-items-center gap-1"
     title="Apple Calendar"
     aria-label="Subscribe in Apple Calendar">
    <i class="bi bi-apple"></i>
    Apple Calendar
  </a>

  <!-- Outlook Web -->
  <a href="https://outlook.live.com/calendar/0/addfromweb?url=https://calendar.google.com/calendar/ical/hppcshared%40gmail.com/public/basic.ics"
     target="_blank"
     class="btn btn-warning rounded-pill d-flex align-items-center gap-1"
     title="Outlook Calendar"
     aria-label="Subscribe in Outlook Web">
    <i class="bi bi-calendar-event"></i>
    Outlook
  </a>
</div>

<!-- Month view embed, responsive -->
<div class="ratio ratio-16x9">
  <iframe
    src="https://calendar.google.com/calendar/embed?src=hppcshared%40gmail.com&ctz=Europe%2FLondon&mode=MONTH"
    style="border:0"
    width="800"
    height="600"
    frameborder="0"
    scrolling="no"
    aria-label="Embedded month view calendar">
  </iframe>
</div>

<!-- Helpful link back to Events -->
<div class="mt-4">
  <a class="btn btn-outline-secondary" href="{{ '/events/' | relative_url }}">View Events with details</a>
</div>

