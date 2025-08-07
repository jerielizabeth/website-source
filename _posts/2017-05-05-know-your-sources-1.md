---
layout: post
title: "Know Your Sources (Part 1)"
tags: digital, research, dissertation

---

*This is [part of a series](http://jeriwieringa.com/portfolio/dissertation/) of technical essays documenting the computational analysis that undergirds my dissertation,* A Gospel of Health and Salvation. *For an overview of the dissertation project, you can read the [current project description](http://jeriwieringa.com/2017/04/21/updated-dissertation-description) at [jeriwieringa.com](http://jeriwieringa.com). You can access the Jupyter notebooks on [Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks).* 

*My goals in sharing the notebooks and technical essays are three-fold. First, I hope that they might prove useful to others interested in taking on similar projects. In these notebooks I describe and model how to approach a large corpus of sources in the production of historical scholarship.* 

*Second, I am sharing them in hopes that "[given enough eyeballs, all bugs are shallow](https://en.wikipedia.org/wiki/Linus%27s_Law )." If you encounter any bugs, if you see an alternative way to solve a problem, or if the code does not achieve the goals I have set out for it, please let me know!*

*Third, these notebooks make an argument for methodological transparency and for the discussion of methods as part of the scholarly argument of digital history. Often the technical work in digital history is done behind the scenes, with publications favoring the final research products, usually in article form with interesting visualizations. While there is a growing culture in digital history of releasing source code, there is little discussion of how that code was developed, why solutions were chosen, and what those solutions enable and prevent. In these notebooks I seek to engage that middle space between code and the final analysis - documenting the computational problem solving that I've done as part of the analysis. As these essays attest, each step in the processing of the corpus requires the researcher to make a myriad of distinctions about the worlds they seek to model, distinctions that shape the outcomes of the computational analysis and are part of the historical argument of the work.*

---

Now that we have a collection of texts [selected and downloaded](http://jeriwieringa.com/2017/04/25/gathering-sources/), and have [extracted the text](http://jeriwieringa.com/2017/04/27/Extract-Text-from-PDFs/), we need to spend some time identifying what the corpus contains, both in terms of coverage and quality. As I describe in the [project overview](http://jeriwieringa.com/2017/04/21/updated-dissertation-description), I will be using these texts to make arguments about the development of the community's discourses around health and salvation. While the corpus makes that analysis possible, it also sets the limits of what we can claim from text analysis alone. Without an understanding of what those limits are, we run the risk of claiming more than the sources can sustain, and in doing so, minimizing the very complexities that historical research seeks to reveal. 


```python
"""My usual practice for gathering the filenames is to read 
them in from a directory. So that this code can be run locally 
without the full corpus downloaded, I exported the list 
of filenames to an index file for use in this notebook.
"""
with open("data/2017-05-05-corpus-index.txt", "r") as f:
    corpus = f.read().splitlines()
```


```python
len(corpus)
```




    197943



To create an overview of the corpus, I will use the document filenames along with some descriptive metadata that I created.

Filenames are an often underestimated feature of digital files, but one that can be used to great effect. For my corpus, the team that digitized the periodicals did an excellent job of providing the files with descriptive names. Overall, the files conform to the following pattern:

`PrefixYYYYMMDD-V00-00.pdf`

I discovered a few files that deviated from the pattern, but renamed those so that the pattern held throughout the corpus. When splitting the PDF documents into pages, I preserved the structure, adding `-page0.txt` to the end. 

The advantage of this format is that the filenames contain the metadata I need to place each file within its context. By isolating the different sections of the filename, I can quickly place any file with reference to the periodical title and the publication date.


```python
import pandas as pd
import re
```


```python
def extract_pub_info(doc_list):
    """Use regex to extract metadata from filename.
    
    Note:
        Assumes that the filename is formatted as::
            
            `PrefixYYYYMMDD-V00-00.pdf`
    
    Args:
        doc_list (list): List of the filenames in the corpus.
    Returns:
        dict: Dictionary with the year and title abbreviation for each filename.
    """
    
    corpus_info = {}
    
    for doc_id in doc_list:
        
        # Split the ID into three parts on the '-'
        split_doc_id = doc_id.split('-')
        
        # Get the prefix by matching the first set of letters 
        # in the first part of the filename.
        title = re.match("[A-Za-z]+", split_doc_id[0])
        # Get the dates by grabbing all of the number elements 
        # in the first part of the filename.
        dates = re.search(r'[0-9]+', split_doc_id[0])
        # The first four numbers is the publication year.
        year = dates.group()[:4]
        
        # Update the dictionary with the title and year 
        # for the filename.
        corpus_info[doc_id] = {'title': title.group(), 'year': year}
    
    return corpus_info
```


```python
corpus_info = extract_pub_info(corpus)
```

One of the most useful libraries in Python for working with data is [Pandas](http://pandas.pydata.org/). With Pandas, Python users gain much of the functionality that our colleagues who work with R have long celebrated as the benefits of that domain-specific language. 

By transforming our `corpus_info` dictionary into a dataframe, we can quickly filter and tabulate a number of different statistics on our corpus.


```python
df = pd.DataFrame.from_dict(corpus_info, orient='index')
```


```python
df.index.name = 'docs'
df = df.reset_index()
```

You can preview the initial dataframe by uncommenting the cell below.


```python
# df
```


```python
df = df.groupby(["title", "year"], as_index=False).docs.count()
```


```python
df
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>title</th>
      <th>year</th>
      <th>docs</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ADV</td>
      <td>1898</td>
      <td>26</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ADV</td>
      <td>1899</td>
      <td>674</td>
    </tr>
    <tr>
      <th>2</th>
      <td>ADV</td>
      <td>1900</td>
      <td>463</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ADV</td>
      <td>1901</td>
      <td>389</td>
    </tr>
    <tr>
      <th>4</th>
      <td>ADV</td>
      <td>1902</td>
      <td>440</td>
    </tr>
    <tr>
      <th>5</th>
      <td>ADV</td>
      <td>1903</td>
      <td>428</td>
    </tr>
    <tr>
      <th>6</th>
      <td>ADV</td>
      <td>1904</td>
      <td>202</td>
    </tr>
    <tr>
      <th>7</th>
      <td>ADV</td>
      <td>1905</td>
      <td>20</td>
    </tr>
    <tr>
      <th>8</th>
      <td>ARAI</td>
      <td>1909</td>
      <td>64</td>
    </tr>
    <tr>
      <th>9</th>
      <td>ARAI</td>
      <td>1919</td>
      <td>32</td>
    </tr>
    <tr>
      <th>10</th>
      <td>AmSn</td>
      <td>1886</td>
      <td>96</td>
    </tr>
    <tr>
      <th>11</th>
      <td>AmSn</td>
      <td>1887</td>
      <td>96</td>
    </tr>
    <tr>
      <th>12</th>
      <td>AmSn</td>
      <td>1888</td>
      <td>105</td>
    </tr>
    <tr>
      <th>13</th>
      <td>AmSn</td>
      <td>1889</td>
      <td>386</td>
    </tr>
    <tr>
      <th>14</th>
      <td>AmSn</td>
      <td>1890</td>
      <td>403</td>
    </tr>
    <tr>
      <th>15</th>
      <td>AmSn</td>
      <td>1891</td>
      <td>398</td>
    </tr>
    <tr>
      <th>16</th>
      <td>AmSn</td>
      <td>1892</td>
      <td>401</td>
    </tr>
    <tr>
      <th>17</th>
      <td>AmSn</td>
      <td>1893</td>
      <td>402</td>
    </tr>
    <tr>
      <th>18</th>
      <td>AmSn</td>
      <td>1894</td>
      <td>402</td>
    </tr>
    <tr>
      <th>19</th>
      <td>AmSn</td>
      <td>1895</td>
      <td>400</td>
    </tr>
    <tr>
      <th>20</th>
      <td>AmSn</td>
      <td>1896</td>
      <td>408</td>
    </tr>
    <tr>
      <th>21</th>
      <td>AmSn</td>
      <td>1897</td>
      <td>800</td>
    </tr>
    <tr>
      <th>22</th>
      <td>AmSn</td>
      <td>1898</td>
      <td>804</td>
    </tr>
    <tr>
      <th>23</th>
      <td>AmSn</td>
      <td>1899</td>
      <td>801</td>
    </tr>
    <tr>
      <th>24</th>
      <td>AmSn</td>
      <td>1900</td>
      <td>800</td>
    </tr>
    <tr>
      <th>25</th>
      <td>CE</td>
      <td>1909</td>
      <td>104</td>
    </tr>
    <tr>
      <th>26</th>
      <td>CE</td>
      <td>1910</td>
      <td>312</td>
    </tr>
    <tr>
      <th>27</th>
      <td>CE</td>
      <td>1911</td>
      <td>312</td>
    </tr>
    <tr>
      <th>28</th>
      <td>CE</td>
      <td>1912</td>
      <td>306</td>
    </tr>
    <tr>
      <th>29</th>
      <td>CE</td>
      <td>1913</td>
      <td>420</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>465</th>
      <td>YI</td>
      <td>1885</td>
      <td>192</td>
    </tr>
    <tr>
      <th>466</th>
      <td>YI</td>
      <td>1886</td>
      <td>220</td>
    </tr>
    <tr>
      <th>467</th>
      <td>YI</td>
      <td>1887</td>
      <td>244</td>
    </tr>
    <tr>
      <th>468</th>
      <td>YI</td>
      <td>1888</td>
      <td>104</td>
    </tr>
    <tr>
      <th>469</th>
      <td>YI</td>
      <td>1889</td>
      <td>208</td>
    </tr>
    <tr>
      <th>470</th>
      <td>YI</td>
      <td>1890</td>
      <td>208</td>
    </tr>
    <tr>
      <th>471</th>
      <td>YI</td>
      <td>1895</td>
      <td>416</td>
    </tr>
    <tr>
      <th>472</th>
      <td>YI</td>
      <td>1898</td>
      <td>28</td>
    </tr>
    <tr>
      <th>473</th>
      <td>YI</td>
      <td>1899</td>
      <td>408</td>
    </tr>
    <tr>
      <th>474</th>
      <td>YI</td>
      <td>1900</td>
      <td>408</td>
    </tr>
    <tr>
      <th>475</th>
      <td>YI</td>
      <td>1901</td>
      <td>408</td>
    </tr>
    <tr>
      <th>476</th>
      <td>YI</td>
      <td>1902</td>
      <td>408</td>
    </tr>
    <tr>
      <th>477</th>
      <td>YI</td>
      <td>1903</td>
      <td>408</td>
    </tr>
    <tr>
      <th>478</th>
      <td>YI</td>
      <td>1904</td>
      <td>288</td>
    </tr>
    <tr>
      <th>479</th>
      <td>YI</td>
      <td>1905</td>
      <td>408</td>
    </tr>
    <tr>
      <th>480</th>
      <td>YI</td>
      <td>1906</td>
      <td>408</td>
    </tr>
    <tr>
      <th>481</th>
      <td>YI</td>
      <td>1907</td>
      <td>432</td>
    </tr>
    <tr>
      <th>482</th>
      <td>YI</td>
      <td>1908</td>
      <td>832</td>
    </tr>
    <tr>
      <th>483</th>
      <td>YI</td>
      <td>1909</td>
      <td>844</td>
    </tr>
    <tr>
      <th>484</th>
      <td>YI</td>
      <td>1910</td>
      <td>850</td>
    </tr>
    <tr>
      <th>485</th>
      <td>YI</td>
      <td>1911</td>
      <td>852</td>
    </tr>
    <tr>
      <th>486</th>
      <td>YI</td>
      <td>1912</td>
      <td>868</td>
    </tr>
    <tr>
      <th>487</th>
      <td>YI</td>
      <td>1913</td>
      <td>848</td>
    </tr>
    <tr>
      <th>488</th>
      <td>YI</td>
      <td>1914</td>
      <td>852</td>
    </tr>
    <tr>
      <th>489</th>
      <td>YI</td>
      <td>1915</td>
      <td>852</td>
    </tr>
    <tr>
      <th>490</th>
      <td>YI</td>
      <td>1916</td>
      <td>852</td>
    </tr>
    <tr>
      <th>491</th>
      <td>YI</td>
      <td>1917</td>
      <td>840</td>
    </tr>
    <tr>
      <th>492</th>
      <td>YI</td>
      <td>1918</td>
      <td>850</td>
    </tr>
    <tr>
      <th>493</th>
      <td>YI</td>
      <td>1919</td>
      <td>856</td>
    </tr>
    <tr>
      <th>494</th>
      <td>YI</td>
      <td>1920</td>
      <td>45</td>
    </tr>
  </tbody>
</table>
<p>495 rows × 3 columns</p>
</div>



Nearly 500 rows of data is too large to have a good sense of the coverage of the corpus from reading the data table, so it is necessary to create some visualizations of the records. For a quick prototyping tool, I am using the [`Bokeh`](http://bokeh.pydata.org/en/latest/) library.


```python
from bokeh.charts import Bar, show
from bokeh.charts import defaults
from bokeh.io import output_notebook
from bokeh.palettes import viridis
```


```python
output_notebook()
```

```python
defaults.width = 900
defaults.height = 950
```

In this first graph, I am showing the total number of pages per title, per year in the corpus.


```python
p = Bar(df, 
        'year', 
        values='docs',
        agg='sum', 
        stack='title',
        palette= viridis(30), 
        title="Pages per Title per Year")
```


```python
show(p)
```

{% include image.html name="2017-05-05-pages-title-year.png" %}

This graph of the corpus reflects the historical development of the publication efforts denomination. Starting with a single publication in 1849, the publishing efforts of the denomination expand in the 1860s as they launch their health reform efforts, expand again in the 1880s as they start a publishing house in California and address concerns about Sunday observance laws, and again at the turn of the century as the denomination reorganizes and regional publications expand. The chart also reveals some holes in the corpus. The *Youth's Instructor* (shown here in yellow) in one of the oldest continuous denominational publications, but the pages available for the years from 1850 - 1899 are inconsistent.

In interpreting the results of mining these texts, it will be important to factor in the relative difference in size and diversity of publication venues between the early years of the denomination and the later years of this study. 


```python
by_title = df.groupby(["title"], as_index=False).docs.sum()
```


```python
p = Bar(df, 
        'title', 
        values='docs', 
        color='title', 
        palette=viridis(30), 
        title="Total Pages by Title"
       )
```


```python
show(p)
```

{% include image.html name="2017-05-05-pages-title.png" %}


Another way to view the coverage of the corpus is by total pages per periodical title. The *Advent Review and Sabbath Herald* dominates the corpus in number of pages, with *The Health Reformer*, *Signs of the Times*, and the *Youth's Instructor*, making up the next major percentage of the corpus. In terms of scale, these publications will have (and had) a prominent role in shaping the discourse of the SDA community. At the same time, it will be informative to look to the smaller publications to see if we can surface alternative and dissonant ideas.


```python
topic_metadata = pd.read_csv('data/2017-05-05-periodical-topics.csv')
```


```python
topic_metadata
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>periodicalTitle</th>
      <th>title</th>
      <th>startYear</th>
      <th>endYear</th>
      <th>initialPubLocation</th>
      <th>topic</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Training School Advocate</td>
      <td>ADV</td>
      <td>1898</td>
      <td>1905</td>
      <td>Battle Creek, MI</td>
      <td>Education</td>
    </tr>
    <tr>
      <th>1</th>
      <td>American Sentinel</td>
      <td>AmSn</td>
      <td>1886</td>
      <td>1900</td>
      <td>Oakland, CA</td>
      <td>Religious Liberty</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Advent Review and Sabbath Herald</td>
      <td>ARAI</td>
      <td>1909</td>
      <td>1919</td>
      <td>Washington, D.C.</td>
      <td>Denominational</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Christian Education</td>
      <td>CE</td>
      <td>1909</td>
      <td>1920</td>
      <td>Washington, D.C.</td>
      <td>Education</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Welcome Visitor (Columbia Union Visitor)</td>
      <td>CUV</td>
      <td>1901</td>
      <td>1920</td>
      <td>Academia, OH</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Christian Educator</td>
      <td>EDU</td>
      <td>1897</td>
      <td>1899</td>
      <td>Battle Creek, MI</td>
      <td>Education</td>
    </tr>
    <tr>
      <th>6</th>
      <td>General Conference Bulletin</td>
      <td>GCB</td>
      <td>1863</td>
      <td>1918</td>
      <td>Battle Creek, MI</td>
      <td>Denominational</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Gospel Herald</td>
      <td>GH</td>
      <td>1898</td>
      <td>1920</td>
      <td>Yazoo City, MS</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Gospel of Health</td>
      <td>GOH</td>
      <td>1897</td>
      <td>1899</td>
      <td>Battle Creek, MI</td>
      <td>Health</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Gospel Sickle</td>
      <td>GS</td>
      <td>1886</td>
      <td>1888</td>
      <td>Battle Creek, MI</td>
      <td>Missions</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Home Missionary</td>
      <td>HM</td>
      <td>1889</td>
      <td>1897</td>
      <td>Battle Creek, MI</td>
      <td>Missions</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Health Reformer</td>
      <td>HR</td>
      <td>1866</td>
      <td>1907</td>
      <td>Battle Creek, MI</td>
      <td>Health</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Indiana Reporter</td>
      <td>IR</td>
      <td>1901</td>
      <td>1910</td>
      <td>Indianapolis, IN</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Life Boat</td>
      <td>LB</td>
      <td>1898</td>
      <td>1920</td>
      <td>Chicago, IL</td>
      <td>Missions</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Life and Health</td>
      <td>LH</td>
      <td>1904</td>
      <td>1920</td>
      <td>Washington, D.C.</td>
      <td>Health</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Liberty</td>
      <td>LibM</td>
      <td>1906</td>
      <td>1920</td>
      <td>Washington, D.C.</td>
      <td>Religious Liberty</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Lake Union Herald</td>
      <td>LUH</td>
      <td>1908</td>
      <td>1920</td>
      <td>Berrien Springs, MI</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>17</th>
      <td>North Michigan News Sheet</td>
      <td>NMN</td>
      <td>1907</td>
      <td>1910</td>
      <td>Petoskey, MI</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Pacific Health Journal and Temperance Advocate</td>
      <td>PHJ</td>
      <td>1885</td>
      <td>1904</td>
      <td>Oakland, CA</td>
      <td>Health</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Present Truth (Advent Review)</td>
      <td>PTAR</td>
      <td>1849</td>
      <td>1850</td>
      <td>Middletown, CT</td>
      <td>Denominational</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Pacific Union Recorder</td>
      <td>PUR</td>
      <td>1901</td>
      <td>1920</td>
      <td>Oakland, CA</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Review and Herald</td>
      <td>RH</td>
      <td>1850</td>
      <td>1920</td>
      <td>Paris, ME</td>
      <td>Denominational</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Sligonian</td>
      <td>Sligo</td>
      <td>1916</td>
      <td>1920</td>
      <td>Washington, D.C.</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Sentinel of Liberty</td>
      <td>SOL</td>
      <td>1900</td>
      <td>1904</td>
      <td>Chicago, IL</td>
      <td>Religious Liberty</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Signs of the Times</td>
      <td>ST</td>
      <td>1874</td>
      <td>1920</td>
      <td>Oakland, CA</td>
      <td>Denominational</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Report of Progress, Southern Union Conference</td>
      <td>SUW</td>
      <td>1907</td>
      <td>1920</td>
      <td>Nashville, TN</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Church Officer's Gazette</td>
      <td>TCOG</td>
      <td>1914</td>
      <td>1920</td>
      <td>Washington, D.C.</td>
      <td>Denominational</td>
    </tr>
    <tr>
      <th>27</th>
      <td>The Missionary Magazine</td>
      <td>TMM</td>
      <td>1898</td>
      <td>1902</td>
      <td>Philadelphia, PA</td>
      <td>Missions</td>
    </tr>
    <tr>
      <th>28</th>
      <td>West Michigan Herald</td>
      <td>WMH</td>
      <td>1903</td>
      <td>1908</td>
      <td>Grand Rapids, MI</td>
      <td>Regional</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Youth's Instructor</td>
      <td>YI</td>
      <td>1852</td>
      <td>1920</td>
      <td>Rochester, NY</td>
      <td>Denominational</td>
    </tr>
  </tbody>
</table>
</div>



We can generate another view by adding some external metadata for the titles. The "topics" listed here are ones I assigned when skimming the different titles. "Denominational" refers to centrally produced publications, covering a wide array of topics. "Education" refers to periodicals focused on education. "Health" to publications focused on health. "Missions" titles are focused on outreach and evangelism focused publications and "Religious Liberty" on governmental concerns over Sabbath laws. Finally, "Regional" refers to periodicals produced by local union conferences, which like the denominational titles cover a wide range of topics.


```python
by_topic = pd.merge(topic_metadata, df, on='title')
```


```python
p = Bar(by_topic, 
        'year', 
        values='docs',
        agg='sum', 
        stack='topic',
        palette= viridis(6), 
        title="Pages per Topic per Year")
```


```python
show(p)
```

{% include image.html name="2017-05-05-pages-topic-year.png" %}


Here we can see the diversification of periodical subjects over time, especially around the turn of the century.


```python
p = Bar(by_topic, 
        'topic', 
        values='docs',
        agg='sum', 
        stack='title',
        palette= viridis(30), 
        title="Pages per Topic per Year")
```


```python
p.left[0].formatter.use_scientific = False
p.legend.location = "top_right"
```


```python
show(p)
```

{% include image.html name="2017-05-05-pages-topic.png" %}

Grouping by category allows us to see that our corpus is dominated by the denominational, health, and regionally focused publications. These topics match with our research concerns, increasing our confidence that we will have enough information to determine meaningful patterns about those topics. But, due to the focus of the corpus, we should proceed cautiously before making any claims about the relative importance of those topics within the community. 

Now that we have a sense of the temporal and topical coverage of our corpus, we will next turn our attention to evaluating the quality of the data that we have gathered from the scanned PDF files.

*You can run this code locally using the [Jupyter notebook available via Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/blogPosts/Know%20Your%20Sources%20(Part%201).ipynb)*.

