---
layout: post
title: "Downloading Corpus Files"
tags: digital, research, dissertation

---

*This is [part of a series](http://jeriwieringa.com/portfolio/dissertation/) of first drafts of the technical essays documenting the technical work that undergirds my dissertation,* A Gospel of Health and Salvation. *For an overview of the dissertation project, you can read the [current project description](http://jeriwieringa.com/2017/04/21/updated-dissertation-description) at [jeriwieringa.com](http://jeriwieringa.com). You can access the Jupyter notebooks on [Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks).* 

*My goals in sharing the notebooks and technical essays are two-fold. First, I hope that they might prove useful to others interested in taking on similar projects. Second, I am sharing them in hopes that "[given enough eyeballs, all bugs are shallow](https://en.wikipedia.org/wiki/Linus%27s_Law )."*

---

The source base for *A Gospel of Health and Salvation* is the collection of scanned periodicals produced by the [Office of Archives, Statistics, and Research](http://documents.adventistarchives.org/) of the Seventh-day Adventist Church (SDA). That this collection of documents is openly available on the web has been fundamental to the success of this project. One of the greatest challenges for historical scholarship that seeks to leverage large digital collections is access to the relevant materials. While projects such as [Chronicling America](http://chroniclingamerica.loc.gov/) and resources such as the [Digital Public Library of America](http://dp.la) are indispensable, many specialized resources are available only through proprietary databases and library subscriptions that impose limits on the ways scholars can interact with their resources.[^1] 

The publishing of the digital periodicals on the open web by the SDA made it unnecessary for me to navigate through the firewalls (and legal land-mines) of using text from major library databases, a major boon for the digital project.[^3] And, although the site does not provide an API for accessing the documents, the structure of the pages is regular, making the site a good candidate for web scraping. However, relying on an organization to provide its own historical documents raises its own challenges. Due to the interests of the hosting organization, in this case the Seventh-day Adventist Church, the collection is shaped by and shapes a particular narrative of the denomination's history and development. For example, issues of *Good Health*, which was published by John Harvey Kellogg, are (almost entirely) dropped from the SDA's collection after 1907, which corresponds to the point when Kellogg was disfellowshipped from the denomination, even though Kellogg continued its publication into the 1940s.[^2] Such interests do not invalidate the usefulness of the collection, as all archives have limitations and goals, but those interests need to be acknowledged and taken into account in the analysis.

To determine the list of titles that applied to my time and regions of study, I browsed through all of the titles in the [periodicals section of the site](http://documents.adventistarchives.org/Periodicals/Forms/AllFolders.aspx) and compiled a list of titles that fit my geographic and temporal constraints. These are: 

* [Training School Advocate (ADV)](http://documents.adventistarchives.org/Periodicals/ADV)
* [American Sentinel (AmSn)](http://documents.adventistarchives.org/Periodicals/AmSn)
* [Advent Review and Sabbath Herald (ARAI)](http://documents.adventistarchives.org/Periodicals/ARAI)
* [Christian Education (CE)](http://documents.adventistarchives.org/Periodicals/CE)
* [Welcome Visitor (Columbia Union Visitor) (CUV)](http://documents.adventistarchives.org/Periodicals/CUV)
* [Christian Educator (EDU)](http://documents.adventistarchives.org/Periodicals/EDU)
* [General Conference Bulletin (GCB)](http://documents.adventistarchives.org/Periodicals/GCSessionBulletins)
* [Gospel Herald (GH)](http://documents.adventistarchives.org/Periodicals/GH)
* [Gospel of Health (GOH)](http://documents.adventistarchives.org/Periodicals/GOH)
* [Gospel Sickle (GS)](http://documents.adventistarchives.org/Periodicals/GS)
* [Home Missionary (HM)](http://documents.adventistarchives.org/Periodicals/HM)
* [Health Reformer (HR)](http://documents.adventistarchives.org/Periodicals/HR)
* [Indiana Reporter (IR)](http://documents.adventistarchives.org/Periodicals/IR)
* [Life Boat (LB)](http://documents.adventistarchives.org/Periodicals/LB)
* [Life and Health (LH)](http://documents.adventistarchives.org/Periodicals/LH)
* [Liberty (LibM)](http://documents.adventistarchives.org/Periodicals/LibM)
* [Lake Union Herald (LUH)](http://documents.adventistarchives.org/Periodicals/LUH)
* [North Michigan News Sheet (NMN)](http://documents.adventistarchives.org/Periodicals/NMN)
* [Pacific Health Journal and Temperance Advocate (PHJ)](http://documents.adventistarchives.org/Periodicals/PHJ)
* [Present Truth (Advent Review) (PT-AR)](http://documents.adventistarchives.org/Periodicals/PT-AR) (renamed locally to PTAR)
* [Pacific Union Recorder (PUR)](http://documents.adventistarchives.org/Periodicals/PUR)
* [Review and Herald (RH)](http://documents.adventistarchives.org/Periodicals/RH)
* [Sabbath School Quarterly (SSQ)](http://documents.adventistarchives.org/SSQ)
* [Sligonian (Sligo)](http://documents.adventistarchives.org/Periodicals/Sligo)
* [Sentinel of Liberty (SOL)](http://documents.adventistarchives.org/Periodicals/SOL)
* [Signs of the Times (ST)](http://documents.adventistarchives.org/Periodicals/ST)
* [Report of Progress, Southern Union Conference (SUW)](http://documents.adventistarchives.org/Periodicals/SUW)
* [The Church Officer's Gazette (TCOG)](http://documents.adventistarchives.org/Periodicals/TCOG)
* [The Missionary Magazine (TMM)](http://documents.adventistarchives.org/Periodicals/TMM)
* [West Michigan Herald (WMH)](http://documents.adventistarchives.org/Periodicals/WMH)
* [Youth's Instructor (YI)](http://documents.adventistarchives.org/Periodicals/YI)

As this was my first technical task for the dissertation, my initial methods for identifying the URLs for the documents I wanted to download was rather manual. I saved an .html file for each index page that contained documents I wanted to download. I then passed those .html files to a script (similar to that recorded here) that used `BeautifulSoup` to extract the PDF ids, reconstruct the URLs, and write the URLs to a new text file, `scrapeList.txt`. After manually deleting the URLs to any documents that were out of range, I then passed the `scrapeList.txt` file to `wget` using the following syntax:[^4] 

```bash
wget -i scrapeList.txt -w 2 --limit-rate=200k
```

I ran this process for each of the periodical titles included in this study. It took approximately a week to download all 13,000 files to my local machine. The resulting corpus takes up 27.19 GB of space.

This notebook reflects a more automated version of that process, created in 2017 to download missing documents. The example recorded here is for downloading the [Sabbath School Quarterly](http://documents.adventistarchives.org/SSQ/) collection, which I missed during my initial collection phase. 

In these scripts I use the [`requests`](http://docs.python-requests.org/en/master/) library to retrieve the HTML from the document directory pages and [`BeautifulSoup4`](https://www.crummy.com/software/BeautifulSoup/) to locate the filenames. I use [`wget`](https://pypi.python.org/pypi/wget) to download the files.


```python
from bs4 import BeautifulSoup
from os.path import join
import re
import requests
import wget
```


```python
def check_year(pdfID):
    """Use regex to check the year from the PDF filename.

    Args:
        pdfID (str): The filename of the PDF object, formatted as 
            PREFIXYYYYMMDD-V00-00
    """
    split_title = pdfID.split('-')
    title_date = split_title[0]
    date = re.findall(r'[0-9]+', title_date)
    year = date[0][:4]
    if int(year) < 1921:
        return True
    else:
        return False


def filename_from_html(content):
    """Use Beautiful Soup to extract the PDF ids from the HTML page. 

    This script is customized to the structure of the archive pages at
    http://documents.adventistarchives.org/Periodicals/Forms/AllFolders.aspx.

    Args:
        content (str): Content is retrieved from a URL using the `get_html_page` 
            function.
    """
    soup = BeautifulSoup(content, "lxml")
    buttons = soup.find_all('td', class_="ms-vb-title")

    pdfIDArray = []

    for each in buttons:
        links = each.find('a')
        pdfID = links.get_text()
        pdfIDArray.append(pdfID)

    return pdfIDArray


def get_html_page(url):
    """Use the requests library to get HTML content from URL
    
    Args:
        url (str): URL of webpage with content to download.
    """
    r = requests.get(url)

    return r.text
```

The first step is to set the directory where I want to save the downloaded documents, as well as the root URL for the location of the PDF documents. 

This example is set up for the Sabbath School Quarterly.


```python
"""If running locally, you will need to create the `corpus` folder or 
update the path to the location of your choice.
"""
download_directory = "../../corpus/"
baseurl = "http://documents.adventistarchives.org/SSQ/"
```

My next step is to generate a list of the IDs for the documents I want to download. 

Here I download the HTML from the index page URLs and extract the document IDs. To avoid downloading any files outside of my study, I check the year in the ID before adding the document ID to my list of documents to download.


```python
index_page_urls = ["http://documents.adventistarchives.org/SSQ/Forms/AllItems.aspx?View={44c9b385-7638-47af-ba03-cddf16ec3a94}&SortField=DateTag&SortDir=Asc",
              "http://documents.adventistarchives.org/SSQ/Forms/AllItems.aspx?Paged=TRUE&p_SortBehavior=0&p_DateTag=1912-10-01&p_FileLeafRef=SS19121001-04%2epdf&p_ID=457&PageFirstRow=101&SortField=DateTag&SortDir=Asc&&View={44C9B385-7638-47AF-BA03-CDDF16EC3A94}"
             ]
```


```python
docs_to_download = []

for url in index_page_urls: 
    content = get_html_page(url)
    pdfs = filename_from_html(content)
    
    for pdf in pdfs:
        if check_year(pdf):
            print("Adding {} to download list".format(pdf))
            docs_to_download.append(pdf)
        else:
            pass
```

Finally, I loop through all of the filenames, create the URL to the PDF, and use `wget` to download a copy of the document into my directory for processing.


```python
for doc_name in docs_to_download:
    url = join(baseurl, "{}.pdf".format(doc_name))
    print(url)
    wget.download(url, download_directory)
```

You can run this code locally using [the Jupyter notebook](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/6e997d2b97be5d01438867d55562b7708f9975e6/module-2/corpus-creation/Downloading%20Corpus%20Files.ipynb). Setup instructions are available in the project README.

---


[^1]: The library at Northeastern University provides a useful [overview](http://subjectguides.lib.neu.edu/textdatamining) of the different elements one must consider when seeking to mine content in subscription databases. Increasingly, library vendors are seeking to build "research environments" that provide "[workflow and analytical technology that breathes new life into the study of the social sciences and humanities](http://www.gale.com/primary-sources/platform)." It is my opinion that granting vendors control over both the documentary materials and the methods of analysis, however, would be a concerning development for the long-term health of scholarship in the humanities.
[^2]: The University of Michigan is [the archival home of the *Good Health* magazine](https://mirlyn.lib.umich.edu/Record/003935956#0) and [many have been digitized by Google](https://books.google.com/books?id=Hds1AQAAMAAJ&dq=%22Good+Health%22&source=gbs_navlinks_s). The Office of Archives and Research does include a few issues from 1937 and [one from 1942](http://documents.adventistarchives.org/Periodicals/HR/HR19420601-V77-06.pdf), which offers evidence of Kellogg's ongoing editorial work on the title.
[^3]: In recognition of the labor involved in creating the digital assets and to drive traffic back to their site, I am not redistributing any of the PDF files in my dissertation. Copies can be retrieved directly from the denomination's websites.
[^4]: In this syntax I was guided by Ian Milligan's wget lesson. Ian Milligan, "Automated Downloading with Wget," *Programming Historian*, (2012-06-27), http://programminghistorian.org/lessons/automated-downloading-with-wget

