---
layout: page
title: Team
---

{% for developer in site.developers %}
<div class='developer'>
  <img src="{{ developer.gravatar | gravatar }})">
  <h3>{{ developer.name }}</h3>
  <a href="https://github.com/{{ developer.github }}">https://github.com/{{ developer.github }}</a>
</div>
{% endfor %}
