---
layout: post
title: Beautiful Soup Tutorial
author: jeri.elizabeth
permalink: /blog/2012/11/04/beautiful-soup-tutorial-part-1/
tags: digital, teaching
---
*(This tutorial is cross posted at [The Programming Historian][1])*

Version: Python 2.7.2 and BeautifulSoup 4.

This tutorial assumes basic knowledge of HTML, CSS, and the Document Object Model. It also assumes some knowledge of Python. For a more basic introduction to Python, see [Working with Text Files][2]. Most of the work is done in the terminal. For an introduction to using the terminal, see the Scholar&#8217;s Lab [Command Line Bootcamp][3] tutorial.

## What is Beautiful Soup?

### Overview

&#8220;You didn&#8217;t write that awful page. You&#8217;re just trying to get some data out of it. Beautiful Soup is here to help.&#8221; ([Opening lines of Beautiful Soup][4]) Beautiful Soup is a Python library for getting data out of HTML, XML, and other markup languages. Say you&#8217;ve found some webpages that display data relevant to your research, such as date or address information, but that do not provide any way of downloading the data directly. Beautiful Soup helps you pull particular content from a webpage, remove the HTML markup, and save the information. It is a tool for web scraping that helps you clean up and parse the documents you have pulled down from the web. The [Beautiful Soup documentation][4] will give you a sense of variety of things that the Beautiful Soup library will help with, from isolating titles and links, to extracting all of the text from the html tags, to altering the HTML within the document you&#8217;re working with.

### Installing Beautiful Soup

Installing Beautiful Soup is easiest if you have pip or another Python installer already in place. If you don&#8217;t have pip, run through a quick tutorial on [installing both pip and Beautiful Soup][5] to get it running. Once you have pip installed, run the following command in the terminal to install Beautiful Soup:

<pre class="brush: plain; title: ; notranslate" title="">pip install beautifulsoup4</pre>

You may need to preface this line with &#8220;sudo&#8221;, which gives your computer permission to write to your root directories and requires you to re-enter your password. This is the same logic behind you being prompted to enter your password when you install a new program. With sudo, the command is:

<pre class="brush: plain; title: ; notranslate" title="">sudo pip install beautifulsoup4</pre>

<div class="wp-caption aligncenter" style="width: 370px">
  <a href="http://xkcd.com/149/"><img alt="" src="http://imgs.xkcd.com/comics/sandwich.png" width="360" height="299" /></a><p class="wp-caption-text">
    The power of sudo<br />&#8220;Sandwich&#8221; by XKCD
  </p>
</div>

## Application: Extracting names and URLs from an HTML page

### Preview: Where we are going

Because I like to see where the finish line is before starting, I will begin with a view of what we are trying to create. We are attempting to go from a search results page where the html page looks like this:

<pre class="brush: plain; title: ; notranslate" title="">&lt;/pre&gt;
&lt;table border="1" cellspacing="2" cellpadding="3"&gt;
&lt;tbody&gt;
&lt;tr&gt;
&lt;th&gt;Member Name&lt;/th&gt;
&lt;th&gt;Birth-Death&lt;/th&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;&lt;a href="http://bioguide.congress.gov/scripts/biodisplay.pl?index=A000035"&gt;ADAMS, George Madison&lt;/a&gt;&lt;/td&gt;
&lt;td&gt;1837-1920&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;&lt;a href="http://bioguide.congress.gov/scripts/biodisplay.pl?index=A000074"&gt;ALBERT, William Julian&lt;/a&gt;&lt;/td&gt;
&lt;td&gt;1816-1879&lt;/td&gt;
&lt;/tr&gt;
&lt;tr&gt;
&lt;td&gt;&lt;a href="http://bioguide.congress.gov/scripts/biodisplay.pl?index=A000077"&gt;ALBRIGHT, Charles&lt;/a&gt;&lt;/td&gt;
&lt;td&gt;1830-1880&lt;/td&gt;
&lt;/tr&gt;
&lt;/tbody&gt;
&lt;/table&gt;
&lt;pre&gt;</pre>

to a CSV file with names and urls that looks like this:

<pre>"ADAMS, George Madison",http://bioguide.congress.gov/scripts/biodisplay.pl?index=A000035
"ALBERT, William Julian",http://bioguide.congress.gov/scripts/biodisplay.pl?index=A000074
"ALBRIGHT, Charles",http://bioguide.congress.gov/scripts/biodisplay.pl?index=A000077</pre>

using a Python script like this:

<pre class="brush: python; title: ; notranslate" title="">from bs4 import BeautifulSoup
import csv

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

f = csv.writer(open("43rd_Congress.csv", "w"))
f.writerow(["Name", "Link"])    # Write column headers as the first line

links = soup.find_all('a')
for link in links:
    names = link.contents[0]
    fullLink = link.get('href')

    f.writerow([names,fullLink])
</pre>

This tutorial explains to how to assemble the final code.

### Get a webpage to scrape

The first step is getting a copy of the HTML page(s) want to scrape. You can combine BeautifulSoup with [urllib3][6] to work directly with pages on the web. This tutorial, however, focuses on using BeautifulSoup with local (downloaded) copies of html files. The Congressional database that we&#8217;re using is not an easy one to scrape because the URL for the search results remains the same regardless of what you&#8217;re searching for. While this can be bypassed programmatically, it is easier for our purposes to go to <a href="http://bioguide.congress.gov/biosearch/biosearch.asp" target="_blank">http://bioguide.congress.gov/biosearch/biosearch.asp</a>, search for Congress number 43, and to save a copy of the results page.

<div id="attachment_2108" class="wp-caption aligncenter" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Congressional-Biographical-Directory-CLERKWEB-2013-08-23-12-22-12.jpg"><img class="size-medium wp-image-2108 " alt="Figure 1: BioGuide Interface Search for 43rd Congress " src="http://programminghistorian.org/wp-content/uploads/2012/12/Congressional-Biographical-Directory-CLERKWEB-2013-08-23-12-22-12-300x258.jpg" width="300" height="258" /></a><p class="wp-caption-text">
    Figure 1: BioGuide Interface<br />Search for 43rd Congress
  </p>
</div>

<div id="attachment_2109" class="wp-caption aligncenter" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Congressional-Biographical-Directory-Results-2013-08-23-12-25-09.jpg"><img class="size-medium wp-image-2109 " alt="Figure 2: BioGuide Results We want to download the HTML behind this page." src="http://programminghistorian.org/wp-content/uploads/2012/12/Congressional-Biographical-Directory-Results-2013-08-23-12-25-09-300x234.jpg" width="300" height="234" /></a><p class="wp-caption-text">
    Figure 2: BioGuide Results<br />We want to download the HTML behind this page
  </p>
</div>

Selecting &#8220;File&#8221; and &#8220;Save Page As &#8230;&#8221; from your browser window will accomplish this (life will be easier if you avoid using spaces in your filename). I have used &#8220;43rd-congress.html&#8221;. Move the file into the folder you want to work in. (To learn how to automate the downloading of HTML pages using Python, see [Automated Downloading with Wget][7] and [Downloading Multiple Records Using Query Strings][8].)

### Identify content

One of the first things Beautiful Soup can help us with is locating content that is buried within the HTML structure. Beautiful Soup allows you to select content based upon tags (example: soup.body.p.b finds the first bold item inside a paragraph tag inside the body tag in the document). To get a good view of how the tags are nested in the document, we can use the method &#8220;prettify&#8221; on our soup object. Create a new text file called &#8220;soupexample.py&#8221; in the same location as your downloaded HTML file. This file will contain the Python script that we will be developing over the course of the tutorial. To begin, import the Beautiful Soup library, open the HTML file and pass it to Beautiful Soup, and then print the &#8220;pretty&#8221; version in the terminal.

<pre class="brush: python; title: ; notranslate" title="">from bs4 import BeautifulSoup soup = BeautifulSoup(open("43rd-congress.html")) print(soup.prettify()) </pre>

Save &#8220;soupexample.py&#8221; in the folder with your HTML file and go to the command line. Navigate (use &#8216;cd&#8217;) to the folder you&#8217;re working in and execute the following:

<pre class="brush: plain; title: ; notranslate" title="">python soupexample.py</pre>

You should see your terminal window fill up with a nicely indented version of the original html text (see Figure 3). This is a visual representation of how the various tags relate to one another.

<div id="attachment_2110" class="wp-caption aligncenter" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-103×40-2013-08-23-13-13-01.jpg"><img class="size-medium wp-image-2110 " alt="Figure 3: &quot;Pretty&quot; print of the BioGuide results" src="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-103×40-2013-08-23-13-13-01-300x242.jpg" width="300" height="242" /></a><p class="wp-caption-text">
    Figure 3: &#8220;Pretty&#8221; print of the BioGuide results
  </p>
</div>

### Using BeautifulSoup to select particular content

Remember that we are interested in only the names and URLs of the various member of the 43rd Congress. Looking at the &#8221;pretty&#8221; version of the file, the first thing to notice is that the data we want is not too deeply embedded in the HTML structure. Both the names and the URLs are, most fortunately, embedded in &#8220;<a>&#8221; tags. So, we need to isolate out all of the &#8220;<a>&#8221; tags. We can do this by updating the code in &#8220;soupexample.py&#8221; to the following:

<pre class="brush: python; highlight: [5,7,8]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

links = soup.find_all('a')

for link in links:
    print link
</pre>

Save and run the script again to see all of the anchor tags in the document.

<pre class="brush: plain; title: ; notranslate" title="">python soupexample.py</pre>

One thing to notice is that there is an additional link in our file &#8211; the link for an additional search.

<div id="attachment_2112" class="wp-caption alignnone" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-101×26-2013-08-23-13-25-56.jpg"><img class="size-medium wp-image-2112" alt="Figure 4: The URLs and names, plus one addition." src="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-101×26-2013-08-23-13-25-56-300x164.jpg" width="300" height="164" /></a><p class="wp-caption-text">
    Figure 4: The URLs and names, plus one addition
  </p>
</div>

We can get rid of this with just a few lines of code. Going back to the pretty version, notice that this last &#8220;<a>&#8221; tag is not within the table but is within a &#8220;<p>&#8221; tag.

<div id="attachment_2111" class="wp-caption alignnone" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-103×40-2013-08-23-13-23-07.jpg"><img class="size-medium wp-image-2111" alt="Figure 4: The rogue link" src="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-103×40-2013-08-23-13-23-07-300x242.jpg" width="300" height="242" /></a><p class="wp-caption-text">
    Figure 5: The rogue link
  </p>
</div>

Because Beautiful Soup allows us to modify the HTML, we can remove the &#8220;<a>&#8221; that is under the &#8220;<p>&#8221; before searching for all the &#8220;<a>&#8221; tags. To do this, we can use the &#8220;decompose&#8221; method, which removes the specified content from the &#8220;soup&#8221;. Do be careful when using &#8220;decompose&#8221;&#8212;you are deleting both the HTML tag and all of the data inside of that tag. If you have not correctly isolated the data, you may be deleting information that you wanted to extract. Update the file as below and run again.

<pre class="brush: python; highlight: [5,6]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

links = soup.find_all('a')

for link in links:
    print link
</pre>

<div id="attachment_2113" class="wp-caption alignnone" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-101×26-2013-08-23-13-28-04.jpg"><img class="size-medium wp-image-2113" alt="Figure 6: Successfully isolated only names and URLs" src="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-101×26-2013-08-23-13-28-04-300x164.jpg" width="300" height="164" /></a><p class="wp-caption-text">
    Figure 6: Successfully isolated only names and URLs
  </p>
</div>

Success! We have isolated out all of the links we want and none of the links we don&#8217;t!

### Stripping Tags and Writing Content to a CSV file

But, we are not done yet! There are still HTML tags surrounding the URL data that we want. And we need to save the data into a file in order to use it for other projects. In order to clean up the HTML tags and split the URLs from the names, we need to isolate the information from the anchor tags. To do this, we will use two powerful, and commonly used Beautiful Soup methods: contents and get. Where before we told the computer to print each link, we now want the computer to separate the link into its parts and print those separately. For the names, we can use link.contents. The &#8220;contents&#8221; method isolates out the text from within html tags. For example, if you started with

<pre>&lt;h2&gt;This is my Header text&lt;/h2&gt;</pre>

you would be left with &#8220;This is my Header text&#8221; after applying the contents method. In this case, we want the contents inside the first tag in &#8220;link&#8221;. (There is only one tag in &#8220;link&#8221;, but since the computer doesn&#8217;t realize that, we must tell it to use the first tag.) For the URL, however, &#8220;contents&#8221; does not work because the URL is part of the HTML tag. Instead, we will use &#8220;get&#8221;, which allow us to pull the text associated with (is on the other side of the &#8220;=&#8221; of) the &#8220;href&#8221; element.

<pre class="brush: python; highlight: [10,11,12,13]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

links = soup.find_all('a')
for link in links:
    names = link.contents[0]
    fullLink = link.get('href')
    print names
    print fullLink
</pre>

<div id="attachment_2114" class="wp-caption alignnone" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-101×26-2013-08-23-14-13-13.jpg"><img class="size-medium wp-image-2114" alt="Figure 7: All HTML tags have been removed" src="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-101×26-2013-08-23-14-13-13-300x164.jpg" width="300" height="164" /></a><p class="wp-caption-text">
    Figure 7: All HTML tags have been removed
  </p>
</div>

Finally, we want to use the CSV library to write the file. First, we need to import the CSV library into the script with &#8220;import csv.&#8221; Next, we create the new CSV file when we &#8220;open&#8221; it using &#8220;csv.writer&#8221;. The &#8220;w&#8221; tells the computer to &#8220;write&#8221; to the file. And to keep everything organized, let&#8217;s write some column headers. Finally, as each line is processed, the name and URL information is written to our CSV file.

<pre class="brush: python; highlight: [2,9,10,14,15,17]; title: ; notranslate" title="">from bs4 import BeautifulSoup
import csv

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

f = csv.writer(open("43rd_Congress.csv", "w"))
f.writerow(["Name", "Link"]) # Write column headers as the first line

links = soup.find_all('a')
for link in links:
    names = link.contents[0]
    fullLink = link.get('href')

    f.writerow([names, fullLink])
</pre>

When executed, this gives us a clean CSV file that we can then use for other purposes.

<div id="attachment_2115" class="wp-caption alignnone" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/43rd_Congress-2-2013-08-23-14-18-27.jpg"><img class="size-medium wp-image-2115" alt="Figure 8: CSV file of results" src="http://programminghistorian.org/wp-content/uploads/2012/12/43rd_Congress-2-2013-08-23-14-18-27-300x125.jpg" width="300" height="125" /></a><p class="wp-caption-text">
    Figure 8: CSV file of results
  </p>
</div>

We have solved our puzzle and have extracted names and URLs from the HTML file.

* * *

## But wait! What if I want ALL of the data?

Let&#8217;s extend our project to capture all of the data from the webpage. We know all of our data can be found inside a table, so let&#8217;s use &#8220;<tr>&#8221; to isolate the content that we want.

<pre class="brush: python; highlight: [8,9,10]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

trs = soup.find_all('tr')
for tr in trs:
    print tr
</pre>

Looking at the print out in the terminal, you can see we have selected a lot more content than when we searched for &#8220;<a>&#8221; tags. Now we need to sort through all of these lines to separate out the different types of data.

<div id="attachment_2117" class="wp-caption alignnone" style="width: 310px">
  <a href="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-142×40-2013-08-23-16-51-22.jpg"><img class="size-medium wp-image-2117" alt="Figure 8: All of the Table Row data" src="http://programminghistorian.org/wp-content/uploads/2012/12/Beautiful-Soup-Tutorial-—-bash-—-142×40-2013-08-23-16-51-22-300x176.jpg" width="300" height="176" /></a><p class="wp-caption-text">
    Figure 8: All of the Table Row data
  </p>
</div>

### Extracting the Data

We can extract the data in two moves. First, we will isolate the link information; then, we will parse the rest of the table row data. For the first, let&#8217;s create a loop to search for all of the anchor tags and &#8220;get&#8221; the data associated with &#8220;href&#8221;.

<pre class="brush: python; highlight: [12,13,14]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

trs = soup.find_all('tr')

for tr in trs:
    for link in tr.find_all('a'):
        fulllink = link.get ('href')
        print fulllink #print in terminal to verify results
</pre>

We then need to run a search for the table data within the table rows. (The &#8220;print&#8221; here allows us to verify that the code is working but is not necessary.)

<pre class="brush: python; highlight: [15,16]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

trs = soup.find_all('tr')

for tr in trs:
    for link in tr.find_all('a'):
        fulllink = link.get ('href')
        print fulllink #print in terminal to verify results

    tds = tr.find_all("td")
    print tds
</pre>

Next, we need to extract the data we want. We know that everything we want for our CSV file lives within table data (&#8220;td&#8221;) tags. We also know that these items appear in the same order within the row. Because we are dealing with lists, we can identify information by its position within the list. This means that the first data item in the row is identified by [0], the second by [1], etc. Because not all of the rows contain the same number of data items, we need to build in a way to tell the script to move on if it encounters an error. This is the logic of the &#8220;try&#8221; and &#8220;except&#8221; block. If a particular line fails, the script will continue on to the next line.

<pre class="brush: python; highlight: [17,18,19,20,21,22,23,24,25,26,27,28,29]; title: ; notranslate" title="">from bs4 import BeautifulSoup

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

trs = soup.find_all('tr')

for tr in trs:
    for link in tr.find_all('a'):
        fulllink = link.get ('href')
        print fulllink #print in terminal to verify results

    tds = tr.find_all("td")

    try: #we are using "try" because the table is not well formatted. This allows the program to continue after encountering an error.
        names = str(tds[0].get_text()) # This structure isolate the item by its column in the table and converts it into a string.
        years = str(tds[1].get_text())
        positions = str(tds[2].get_text())
        parties = str(tds[3].get_text())
        states = str(tds[4].get_text())
        congress = tds[5].get_text()

    except:
        print "bad tr string"
        continue #This tells the computer to move on to the next item after it encounters an error

    print names, years, positions, parties, states, congress
</pre>

Within this we are using the following structure:

<pre class="brush: python; title: ; notranslate" title="">years = str(tds[1].get_text())</pre>

We are applying the &#8220;get_text&#8221; method to the 2nd element in the row (because computers count beginning with 0) and creating a string from the result. This we assign to the variable &#8220;years&#8221;, which we will use to create the CSV file. We repeat this for every item in the table that we want to capture in our file.

### Writing the CSV file

The last step in this file is to create the CSV file. Here we are using the same process as we did in Part I, just with more variables. As a result, our file will look like:

<pre class="brush: python; highlight: [2,9,10,32]; title: ; notranslate" title="">from bs4 import BeautifulSoup
import csv

soup = BeautifulSoup (open("43rd-congress.html"))

final_link = soup.p.a
final_link.decompose()

f= csv.writer(open("43rd_Congress_all.csv", "w"))   # Open the output file for writing before the loop
f.writerow(["Name", "Years", "Position", "Party", "State", "Congress", "Link"]) # Write column headers as the first line

trs = soup.find_all('tr')

for tr in trs:
    for link in tr.find_all('a'):
        fullLink = link.get ('href')

    tds = tr.find_all("td")

    try: #we are using "try" because the table is not well formatted. This allows the program to continue after encountering an error.
        names = str(tds[0].get_text()) # This structure isolate the item by its column in the table and converts it into a string.
        years = str(tds[1].get_text())
        positions = str(tds[2].get_text())
        parties = str(tds[3].get_text())
        states = str(tds[4].get_text())
        congress = tds[5].get_text()

    except:
        print "bad tr string"
        continue #This tells the computer to move on to the next item after it encounters an error

    f.writerow([names, years, positions, parties, states, congress, fullLink])
</pre>

You&#8217;ve done it! You have created a CSV file from all of the data in the table, creating useful data from the confusion of the html page.

 [1]: http://programminghistorian.org/lessons/intro-to-beautiful-soup
 [2]: http://programminghistorian.org/lessons/working-with-text-files
 [3]: http://praxis.scholarslab.org/tutorials/bash/
 [4]: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
 [5]: http://programminghistorian.org/lessons/installing-pip-and-beautiful-soup
 [6]: http://urllib3.readthedocs.org/en/latest/
 [7]: http://programminghistorian.org/lessons/automated-downloading-with-wget
 [8]: http://programminghistorian.org/lessons/downloading-multiple-records-using-query-strings
