---
layout: post
title: "Extracting Text from PDFs"
tags: digital, research, dissertation

---

*This is [part of a series](http://jeriwieringa.com/portfolio/dissertation/) of first drafts of the technical essays documenting the technical work that undergirds my dissertation,* A Gospel of Health and Salvation. *For an overview of the dissertation project, you can read the [current project description](http://jeriwieringa.com/2017/04/21/updated-dissertation-description) at [jeriwieringa.com](http://jeriwieringa.com). You can access the Jupyter notebooks on [Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks).* 

*My goals in sharing the notebooks and technical essays are two-fold. First, I hope that they might prove useful to others interested in taking on similar projects. Second, I am sharing them in hopes that "[given enough eyeballs, all bugs are shallow](https://en.wikipedia.org/wiki/Linus%27s_Law )."*

---

With the PDF files downloaded, my next challenge was to extract the text. Here my choice of source base offered some advantages and some additional challenges. It is not uncommon when downloading books scanned to PDFs from providers such as Google to discover that they have only made the page images available. As many people want textual data, and preferably good textual data, for a variety of potentially lucrative computational tasks, it makes sense for companies to withhold the text layer. But for the researcher, this necessitates adding a text recognition step to the gathering process, running the pages through OCR software to generate the needed text layer. One advantage of this is that you then have control over the OCR software, but it significantly increases the time and complexity of the text gathering process.

The PDF files produced by the [Office of Archives and Statistics](http://documents.adventistarchives.org/default.aspx) include the produced OCR. But unlike the newspapers scanned as part of the [Chronicling America](http://chroniclingamerica.loc.gov/) project, there is very little information embedded in these files about the source and estimated quality of that OCR. That lack of information sets up the challenge for the next section of this module, which documents my work to assess and clean the corpus, [previewed in an earlier blog post](http://jeriwieringa.com/2017/01/09/early_error_summary/).

In extracting the text, I also had to determined my unit of analysis for text mining -- the article, the page, or the issue. I quickly dismissed using the "issue" because it is too large and too irregular a unit. With issues ranging in length from 8 pages to 100 pages, and including a variety of elements from long essays to letters to the editor and field reports, I would only be able to surface summary patterns using the issue as a whole. Since I am interested in identifying shifts in discourse over time, a more fine-grained unit was necessary. For this, the "article" seemed like a very useful unit, enabling each distinct piece to be examined on its own. But the boundaries of "articles" in a newspaper type publication are actually rather hard to define, and the length of the candidate sections range from multiple-page essays to one paragraph letters or poems. In addition, the publications contain a number of article "edge cases", such as advertisements, notices of letters received, and subscription information, which would either need to be identified and separated into their own articles or identified and excluded.

In the end, I chose the middle-ground solution of using the page as the document unit. While not all pages are created equal (early issues of the *Review and Herald* made great use of space and small font size to squeeze about 3000 words on a page), on average the pages contain about 1000 words, placing them in line with the units [Matthew Jockers has found to be most useful when modeling novels](http://www.matthewjockers.net/2013/04/12/secret-recipe-for-topic-modeling-themes/). Splitting on the page is also computationally and analytically simple, which is valuable when working at the scale of this project. 

In addition, using the page as the unit of analysis is more reflective of the print reading experience. Rather than interacting with each article in isolation (as is modeled in many database editions of historical newspapers), the newspaper readers would experience an article within the context of the other stories on the page. This juxtaposition of items creates what Marshall McLuhan refers to as the "human interest" element of news print, constructed through the "mosaic" of the page layout.[^1] Using the page as the unit of analysis enables me to interact with the articles as well as the community that the collection of articles creates.

Having determined the unit of analysis, the technical challenge was how to split the PDF documents and extract the text. It is worth noting that not all of the methods I used to prepare my corpus are ones that I would recommend. For reasons I don't entirely recall, but related to struggling to conceptualize how to write a function that would separate the PDFs and extract the text, I chose [Automator](https://help.apple.com/automator/mac/10.12/index.html?localePath=en.lproj#/aut6e8156d85), a default Mac utility, to separate the pages and extract the text from the PDF files. While this reduced the programming load, it was memory and storage intensive — through the process I managed to destroy a hard-drive by failing to realize that 100-page PDFs take up even more space when split into 100 1-page PDFs. Another downside of using Automator was that I did not have control over [the encoding](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/) of the generated text files. Upon attempting run the files through Python scripts, a plethora of encoding error messages quickly suggested that not all was well with my text corpus. I used the following bash script to check and report the file encodings:

```bash
FILES=*.txt
for f in $FILES
do
  encoding=`file -I $f | cut -f 2 -d";" | cut -f 2 -d=`
  if ! [ $encoding = "utf-8" -o $encoding = "us-ascii" ]; then
    echo "Check $f: encoding reported as $encoding"
  fi 
done
```
The report revealed non-utf-8 encodings from `latin-1` to `binary` on a majority of files. My attempts to use [`iconv`](https://en.wikipedia.org/wiki/Iconv) to convert the files to utf-8 raised their own collection of errors. Thanks to a suggestion from [a very wise friend](http://kimberlylapierre.weebly.com/), I bypassed these problems by using `vim` within a bash script to open each file and re-encode it in utf-8. 

```bash
FILES=*.txt
for f in $FILES
do
  echo "$f"
  vim -es '+set fileencoding=utf-8' '+wq' $f
  encoding=`file -bi $f | cut -f 2 -d";" | cut -f 2 -d=`
  echo "$encoding"
done
```
Although perhaps not an elegant solution, this process worked sufficiently to produce a directory of 197,943 text files that could be read by my Python scripts without trouble.

Below I outline a better way, which I use on later additions to the corpus, to extract the text from a PDF document and save each page to it's own file using [`PyPDF2`](https://pythonhosted.org/PyPDF2/). Using a PDF library has a number of advantages. First, it is much less resource intensive, with no intermediary documents created and, with the use of a [generator expression](https://docs.python.org/3/glossary.html#term-generator), no need to load the entire list of filenames into memory. Second, by placing the extraction within a more typical Python workflow, I can set the encoding when writing the extracted text to a file. This removes the complication I encountered with the Automator-generated text of relying on a program to assign the "most likely" encoding.


```python
import os
from os.path import isfile, join
import PyPDF2
```


```python
"""If running locally, set these variables to your local directories.
"""
pdf_dir = "../../corpus/incoming"
txt_dir = "../../corpus/txt_dir"
```


```python
"""Note: Uses a generator expression.
Rerun the cell if you restart the loop below.
"""
corpus = (f for f in os.listdir(pdf_dir) if not f.startswith('.') and isfile(join(pdf_dir, f)))
```


```python
"""The documentation for PyPDF2 is minimal. 
For this pattern, I followed the syntax at 
https://automatetheboringstuff.com/chapter13/ and
https://github.com/msaxton/iliff_review/blob/master/code/atla_pdfConvert.py
"""
for filename in corpus:
    # Open the PDF and load as PyPDF2 Reader object.
    pdf = open(join(pdf_dir, filename),'rb')
    pdfReader = PyPDF2.PdfFileReader(pdf)
    
    # Loop through the pages, extract the text, and write each page to individual file.
    for page in range(0, pdfReader.numPages):
        pageObj = pdfReader.getPage(page)
        text = pageObj.extractText()
        
        # Compile the page name. Add one because Python counts from 0.
        page_name = "{}-page{}.txt".format(filename[:-4], page+1)

        # Write to each page to file
        with open(join(txt_dir, page_name), mode="w", encoding='utf-8') as o:
            o.write(text)
```

You can run this code locally using [the Jupyter Notebook](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/d6522da8a9ce7e31cb4f08bade7f6762b13463df/module-2/corpus-creation/Extracting%20Text%20from%20PDFs.ipynb). Setup instructions are available in the project README.

---

[^1]: Marshall McLuhan, *Understanding Media: The Extensions of Man.* MIT Press Edition. Cambridge, MA: The MIT Press, 1994. p. 204.

