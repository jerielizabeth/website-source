---
layout: post
title: Learning how to scrape (or how to fill up your harddrive really quickly)
author: jeri.elizabeth

permalink: /blog/2012/10/11/learning-how-to-scrape-or-how-to-fill-up-your-harddrive-really-quickly/
tags: digital, coursework

---
This week I have focused on learning some of the tricks and tips for scraping websites, in preparation for presenting tonight. For the most part, this has gone really well. The existing tutorials on the programming historian for using [wget][1] and [python][2] are very intuitive and easy to follow and most of my presentation will be on these.

Wget is a very useful tool when dealing with a well organized website and I think will be most useful right of the bat for most of us. It&#8217;s quick and easy and run through the command line.

Using Python is a bit more complicated but does allow for more detailed scraping. While I won&#8217;t be focusing on this, you can use Python to not only pull down whole copies of sites but also to filter those sites for particular information before you save it to your own machine (or wherever you&#8217;re saving it).

One problem I am still struggling with is how to cycle through a list of URL using Python. While writing the script to save one file is straightforward enough, I spent much of yesterday looking for any indication of how to save multiple files. I kinda have a loop going on, but can&#8217;t figure out if it is parsing my csv file of links correctly. And I can&#8217;t figure out how to change the file name each time, so even when I get something out, it is rewriting itself in a single file. If I can&#8217;t figure this out today (and I&#8217;m coming for help with this, Fred), I think I can present a work-around using cURL.

Also, it is unclear to me how to build in a wait time when using Python or cURL. Seems that this would be useful in order to be a good internet citizen.

Two discoveries as a result of this. 1. Hymnary.org puts a cap on the calls to the api from a given ip address. oops. and 2. There is a ton more information in the json document that I am looking to call down than I had realized. I think I will be able to do more this semester than I originally thought my data allowed. yippie!!

 [1]: http://programminghistorian.org/lessons/automated-downloading-with-wget
 [2]: http://programminghistorian.org/lessons/working-with-files-and-web-pages