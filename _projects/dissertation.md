---
title: A Gospel of Health and Salvation
layout: page
img: /assets/img/dissertation.jpg
description: Digital Dissertation on Seventh-day Adventism, religion, and gender in American culture.
importance: 5
category: past
related_publications: true
---
*A Gospel of Health and Salvation* is a work of digital history — defined as the critical application of computational technologies to the study of the past — focused on the relationship between time and gender in Seventh-day Adventism. In it I explore the puzzle of the denomination’s prophet and religious leader, Ellen White, and her varied and seemingly contradictory writings on the role of women in the denomination. One of a few women religious leaders in nineteenth-century America, White is difficult to place within the history of American religion. Rising to prominence at the end of the Second Great Awakening, White promoted a vision of gender and women’s participation in the work of salvation that fails to fit neatly into either histories of American feminism or histories of domesticity. Discussing White and her place in American religious history requires a different approach.

![Woman leading rows of guests in exercises outside of the Battle Creek Sanitarium](/assets/img/dissertation.jpg){: .right .col .two}

Using computational text analysis to find broad patterns in the denomination’s periodical record, I highlight three cycles of end-times expectation that shaped the complex vision of gender articulated by White and other denomination leaders during the first seventy years of the denomination. These cycles enable me to bring together two theoretical frameworks often used to analyze the development of religious movements. Rather than a linear trajectory from religious sect to denomination, and concurrently from expansive understandings of gender to restrictive ones, the waves of end-times expectation opened space for alternative and expansive visions of gender at a number of points in the denomination’s early history.

Additionally, I argue for the scholarliness of the computational work that grounds my historical analysis. Rather than neutral, the work of selecting the corpus, preparing the text for analysis, selecting modeling algorithms, visualizing the resulting model, and interpreting the results represents the first phase of interpretation and shapes the possibilities of the overall project. To make this multilayered argument, I created the dissertation as a website, rather than a traditional document. Hosted at [http://dissertation.jeriwieringa.com](http://dissertation.jeriwieringa.com), the web interface interweaves the technical, visual, and narrative aspects of the dissertation arguments. The site brings together a topic model of the denomination’s periodical literature, the code used to create and analyze the model, and four interpretive essays. Together these constitute the body of work that is *A Gospel of Health and Salvation*.

## Dissertation Posts

<ul class="posts">
{% for post in site.tags.dissertation %}
  <div class="post_info">
    <li>
         <span>{{ post.date | date:"%Y-%m-%d" }}</span> | <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
    </div>
  {% endfor %}
</ul>


<span style="font-size:.8em">image credit: "BattleCreekSanitorium". Licensed under Public Domain via Commons - 
<a href="https://commons.wikimedia.org/wiki/File:BattleCreekSanitorium.jpg#/media/File:BattleCreekSanitorium.jpg">https://commons.wikimedia.org/wiki/File:BattleCreekSanitorium.jpg#/media/File:BattleCreekSanitorium.jpg</a></span>



