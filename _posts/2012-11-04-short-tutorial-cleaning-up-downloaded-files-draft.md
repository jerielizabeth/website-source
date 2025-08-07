---
layout: post
title: 'Short Tutorial: Cleaning up downloaded files (draft)'
author: jeri.elizabeth

permalink: /blog/2012/11/04/short-tutorial-cleaning-up-downloaded-files-draft/
tags: coursework

---
So you used wget or Python to pull down a collection of files from the web. Excellent! But in looking through your loot, you notice that a number of the files are oddly small and, on further examination, find that they are functionally empty. How do you clean up your collection of files quickly?

There are a number of very powerful command line tools built into UNIX systems (Mac and Linux) that allow you to manipulate your files quickly and easily. This is a brief tutorial on how to use those tools to locate all of the files that are too small and then remove those files from your collection.

Begin by navigating in Terminal to your collection of folders. For example, my files were located a couple of folders downs within my Documents folder.

<pre>cd Documents/Github/Clio3/Webscraping/hymn-files</pre>

Once in the folder with your downloaded files, you need to find a way to isolate out the files that are too small to be interesting. To do this, use the &#8220;find&#8221; command. First, to see the various options associated with &#8220;find&#8221;, enter

<pre>man help</pre>

Use the up and down arrows to move around the window that appears. Look around at the various options &#8211; there are many! However, because we are looking only in a particular folder, which in my case has no subfolders, all that we need to look at for now is size.

To exit this window, type &#8220;q&#8221;.

If the files we are interested in sorting through are all one file type (in my case they&#8217;re .json files), we can tell the computer to find all of the files of a particular type and particular size as follows:

<pre>find *.json -size 28c</pre>

This would find all of the json files that are 28 bytes in size.

However, we want all the files that are 28 bytes or less.

<pre>find *.json -size -28c</pre>

Finding the files is great, but now we need to do something with that collection of files.

First we are going to &#8220;pipe&#8221; the results of our search over to our second, removal, function.

(From here on the examples are showing how the command is built &#8211; Do not run the command until the very end when all the pieces are in place)

<pre>find *.json -size -28c |</pre>

Next we are going to use xargs, which helps the computer handle a long list of file names.

Note: The wikipedia entry on xargs suggests using &#8220;-0&#8243; (zero) when dealing with file names with spaces in them as xargs defaults to separating at white space (another reason to avoid spaces in filenames). If you run this command without -0 and it doesn&#8217;t work, try adding the -0.

<pre>find *.json -size -28c | xargs</pre>

And the function we want to run on each filename is &#8220;rm&#8221; or remove. rm has a number of options that you can research, some of which really make data un-recoverable and should be used with care. However, a basic &#8220;rm&#8221; command will be sufficient for this example.

<pre>find *.json -size -28c | xargs rm</pre>

Run this command to remove all of the files less than 28 bytes from your current directory.

(I used 28 bytes because the computer was having trouble with 0 and all of the files I wanted to keep were larger than 28 bytes. Not exactly sure why 0 was a problem but this is why experimenting with the find options before moving on to removing the files is a good idea!)
