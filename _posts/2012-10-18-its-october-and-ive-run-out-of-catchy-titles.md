---
layout: post
title: 'It&#8217;s October and I&#8217;ve run out of catchy titles &#8230;'
author: jeri.elizabeth

permalink: /blog/2012/10/18/its-october-and-ive-run-out-of-catchy-titles/
tags: digital, coursework

---
So, this week was both productive and not. I find that I learn in circles &#8211; I have to go over things about 3 times for connections between things to get to the point that I feel like I have learned something. (They told us this in philosophy too &#8211;  read it 3 times to understand what is going on. Now, if they assigned the same thing 3 times &#8230;)

Anyway, in light of this pattern, I went back to some tutorials. I spent too much time on the first 17 tutorials of &#8220;[Learn Python the Hard Way][1]&#8221; and then, because I got a bit distractable at that point, did the first 13 of &#8220;[Learn SQL the Hard Way][2].&#8221; (I have a feeling [&#8220;Learn Regex&#8230;&#8221;][3] is in my future &#8230;)

At any rate, the SQL tutorials were really helpful in a, &#8220;well, duh. I should&#8217;ve picked up on that&#8221; sort of way. So I tweaked my pages to have one query for showing both text and author information, which is super useful and makes everything much cleaner and less confusing. I&#8217;ll push that up to my server so to update [clio3.jeriwieringa.com][4].

There is still more to do with that, but I got distracted again by all of the files I pulled down last week. (seriously, grad school is turning me into a goldfish&#8230; ) At any rate, there was a small problem that most of the 2000 files that I pulled down were 2 bytes large. (they contained an empty array).

So, with much googling, I worked out a bash script to delete all of the really small files. yup.

	%pre find *.json -size -28c | xargs rm

I was in folder already so no file path necessary. Anyway, this deleted all of the files that ended with .json and were smaller than 28 bytes. I tried with 2 bytes, but it was hiccup-ing.

Then I realized I needed to parse out the hymnal IDs so I know which hymnal information to add to my database. (Good news &#8211; there is place info in the hymnal CSV file. It&#8217;s not going to tell me all that much, but it&#8217;s enough to get a sense of where the publishing centers are. And it gives me something to map.) And that&#8217;s where I&#8217;ve slowed to a halt.

I am having trouble getting my head around working with these json files. I know it&#8217;s been explained to me many times, and I know it&#8217;s an array of arrays, but I just can&#8217;t seem to find a basic intro to the syntax for working with it. So that is where I could use the most help this week.

 [1]: http://learnpythonthehardway.org/
 [2]: http://sql.learncodethehardway.org/
 [3]: http://regex.learncodethehardway.org/book/
 [4]: http://clio3.jeriwieringa.com
