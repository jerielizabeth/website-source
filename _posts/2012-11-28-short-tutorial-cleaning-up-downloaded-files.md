---
layout: post
title: 'Short Tutorial: Cleaning up downloaded files'
author: jeri.elizabeth

permalink: /blog/2012/11/28/short-tutorial-cleaning-up-downloaded-files-draft-2/
tags: digital, teaching, tutorial

---
So you used wget or Python to pull down a collection of files from the web. Excellent! But in looking through your loot, you notice that a number of the files are oddly small and, on further examination, find that they are functionally empty. How do you clean up your collection of files quickly?

There are a number of very powerful command line tools built into UNIX systems (Mac and Linux) that allow you to manipulate your files quickly and easily. This is a brief tutorial on how to use those tools to locate all of the files that are too small and then remove those files from your collection.

Begin by navigating in Terminal to your collection of folders. For example, my files were located a couple of folders downs within my Documents folder.

	cd Documents/Github/Clio3/Webscraping/hymn-files

Once in the folder with your downloaded files, you need to find a way to isolate out the files that are too small to be interesting. To do this, use the `find` command.

If the files we are interested in sorting through are all one file type (in my case they're .json files), we can tell the computer to find all of the files of a particular type and particular size as follows:

	find *.json -size 28c

This would find all of the json files that are 28 bytes in size.

However, we want all the files that are 28 bytes or less.

	find *.json -size -28c

This is important in my case because the files are not truly empty. There is a simple way to identify truly empty files, if that is more appropriate for your data.

	find *.json -empty

You can also add

	-maxdepth 1

if there are additional folders that you do not want to work through.

Finding the files is great, but now we need to do something with that collection of files.

There are two ways you can do this. First, you can simply add a delete option to your command, as follows:

	find *.json -size -28c -delete

In general, this should work. However, if you are dealing with a large number of files, it is often better to use a pipe (`|`). The pipe takes the results of the first command and feeds them to the second command. In the example below, we are taking the results of the find command and passing them to the remove command (`rm`).

	find *.json -size -28c | xargs rm

You will notice that we included `xargs` on the right side of the pipe. Xargs helps the computer handle a long list of file names.

Note: The Wikipedia entry on xargs suggests using `-0` (zero) when dealing with file names with spaces in them as xargs defaults to separating at white space (another reason to avoid spaces in filenames). If you run this command without `-0` and it doesn't work, try adding the `-0`.

And the command we are running on each filename is `rm` or remove. rm has a number of options that you can research, some of which really make data un-recoverable and should be used with care. However, a basic `rm` command will be sufficient for this example.

Run this command to remove all of the files less than 28 bytes from your current directory.

(I used 28 bytes because the computer was having trouble with 0 and all of the files I wanted to keep were larger than 28 bytes. Not exactly sure why 0 was a problem but this is why experimenting with the find options before moving on to removing the files is a good idea!)
