---
layout: post
title: "Ways to Compute Topics over Time, Part 3"
tags: digital, research, dissertation

---

*This is [part of a series](http://jeriwieringa.com/portfolio/dissertation/) of technical essays documenting the computational analysis that undergirds my dissertation,* A Gospel of Health and Salvation. *For an overview of the dissertation project, you can read the [current project description](http://jeriwieringa.com/2017/04/21/updated-dissertation-description) at [jeriwieringa.com](http://jeriwieringa.com). You can access the Jupyter notebooks on [Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks).* 

---

This is the third in a series of posts which constitute a "lit review" of sorts, documenting the range of methods scholars are using to compute the distribution of topics over time.

Graphs of topic prevalence over time are some of the most ubiquitous in digital humanities discussions of topic modeling. They are used as a mechanism for identifying spikes in discourse and for depicting the relationship between the various discourses in a corpus.

Topic prevalence over time is not, however, a measure that is returned with the standard modeling tools such as MALLET or Gensim. Instead, it is computed after the fact by combining the model data with external metadata and aggregating the model results. And, as it turns out, there are a number of ways that the data can be aggregated and displayed.
In this series of notebooks, I am looking at 4 different strategies for computing topic significance over time. These strategies are:

+ [Average of topic weights per year (First Post)](http://jeriwieringa.com/2017/06/21/Calculating-and-Visualizing-Topic-Significance-over-Time-Part-1/)
+ [Smoothing or regression analysis (Second Post)](http://jeriwieringa.com/2017/06/23/calculating-and-visualizing-topic-significance-over-time-part-2/)
+ [Prevalence of the top topic per year (Third Post)](http://jeriwieringa.com/2017/06/30/calculating-and-visualizing-topic-significance-over-time-part-3/)
+ Proportion of total weights per year


To explore a range of strategies for computing and visualizing topics over time from a standard LDA model, I am using a model I created from my dissertation materials. You can download the files needed to follow along from [ https://www.dropbox.com/s/9uf6kzkm1t12v6x/2017-06-21.zip?dl=0]( https://www.dropbox.com/s/9uf6kzkm1t12v6x/2017-06-21.zip?dl=0).

If you cloned the notebooks from one of the earlier posts, please pull down the latest version and update your environment (see the [README](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/README.md) for help). I forgot to add a few libraries that are needed to run these notebooks.


```python
# Load the necessary libraries
import json
import logging
import matplotlib.pyplot as plt
import os
import pandas as pd # Note: I am running 0.19.2
import seaborn as sns
```


```python
# Enable in-notebook visualizations
%matplotlib inline
```


```python
pd.options.display.max_rows = 10
```


```python
base_dir = "data"
period = '1859-to-1875'
directory = "historical_periods"
```

# Create the dataframes

I preprocessed the model to export various aspects of the model information into CSV files for ease of compiling. I will be releasing the code I used to export that information in a later notebook. 


```python
metadata_filename = os.path.join(base_dir,'2017-05-corpus-stats/2017-05-Composite-OCR-statistics.csv')
index_filename = os.path.join(base_dir, 'corpora', directory, '{}.txt'.format(period))
labels_filename = os.path.join(base_dir, 'dataframes', directory, '{}_topicLabels.csv'.format(period))
doc_topic_filename = os.path.join(base_dir, 'dataframes', directory, '{}_dtm.csv'.format(period))
```


```python
def doc_list(index_filename):
    """
    Read in from a json document with index position and filename. 
    File was created during the creation of the corpus (.mm) file to document
    the filename for each file as it was processed.
    
    Returns the index information as a dataframe.
    """
    with open(index_filename) as data_file:    
        data = json.load(data_file)
    docs = pd.DataFrame.from_dict(data, orient='index').reset_index()
    docs.columns = ['index_pos', 'doc_id']
    docs['index_pos'] = docs['index_pos'].astype(int)
  
    return docs


def compile_dataframe( index, dtm, labels, metadata):
    """
    Combines a series of dataframes to create a large composit dataframe.
    """
    doc2metadata = index.merge(metadata, on='doc_id', how="left")
    topics_expanded = dtm.merge(labels, on='topic_id')
    
    df = topics_expanded.merge(doc2metadata, on="index_pos", how="left")
    
    return df
```


```python
order = ['conference, committee, report, president, secretary, resolved',
         'quarterly, district, society, send, sept, business',
         'association, publishing, chart, dollar, xxii, sign',
         'mother, wife, told, went, young, school',
         'disease, physician, tobacco, patient, poison, medicine',
         'wicked, immortality, righteous, adam, flesh, hell',
        ]
```


```python
def create_plotpoint(df, y_value, hue=None, order=order, col=None, wrap=None, size=6, aspect=1.5, title=""):
    p = sns.factorplot(x="year", y=y_value, kind='point', hue_order=order, hue=hue, 
                       col=col, col_wrap=wrap, col_order=order, size=size, aspect=aspect, data=df)
    p.fig.subplots_adjust(top=0.9)
    p.fig.suptitle(title, fontsize=16)
    return p
```


```python
metadata = pd.read_csv(metadata_filename, usecols=['doc_id', 'year','title'])
docs_index = doc_list(index_filename)
dt = pd.read_csv(doc_topic_filename)
labels = pd.read_csv(labels_filename)
```

The first step, following the pattern of [Andrew Goldstone for his topic model browser](https://github.com/agoldst/dfrtopics/blob/43362fd4aea25caedf59f610fb02f3aaa30334ca/R/matrices.R#L373-L415), is to normalize the weights for each document, so that they total to "1".

As a note, Goldstone first smooths the weights by adding the alpha hyperparameter to each of the weights, which I am not doing here.


```python
# Reorient from long to wide
dtm = dt.pivot(index='index_pos', columns='topic_id', values='topic_weight').fillna(0)

# Divide each value in a row by the sum of the row to normalize the values
# Since last week I have found a cleaner way to normalize the rows.
# https://stackoverflow.com/questions/18594469/normalizing-a-pandas-dataframe-by-row
dtm = dtm.div(dtm.sum(axis=1), axis=0)

# Shift back to a long dataframe
dt_norm = dtm.stack().reset_index()
dt_norm.columns = ['index_pos', 'topic_id', 'norm_topic_weight']
```


```python
df = compile_dataframe(docs_index, dt_norm, labels, metadata)
```


```python
df
```




<div>
<style>
    .dataframe {
        font-size: 12px;
    }
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>index_pos</th>
      <th>topic_id</th>
      <th>norm_topic_weight</th>
      <th>topic_words</th>
      <th>doc_id</th>
      <th>year</th>
      <th>title</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>0</td>
      <td>0.045525</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
      <td>GCB186305XX-VXX-XX-page1.txt</td>
      <td>1863</td>
      <td>GCB</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>0</td>
      <td>0.000000</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
      <td>GCB186305XX-VXX-XX-page2.txt</td>
      <td>1863</td>
      <td>GCB</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>0</td>
      <td>0.000000</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
      <td>GCB186305XX-VXX-XX-page3.txt</td>
      <td>1863</td>
      <td>GCB</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>0</td>
      <td>0.000000</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
      <td>GCB186305XX-VXX-XX-page4.txt</td>
      <td>1863</td>
      <td>GCB</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>0</td>
      <td>0.000000</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
      <td>GCB186305XX-VXX-XX-page5.txt</td>
      <td>1863</td>
      <td>GCB</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>288595</th>
      <td>11539</td>
      <td>24</td>
      <td>0.000000</td>
      <td>jerusalem, thess, parable, lazarus, thou_hast,...</td>
      <td>YI18721201-V20-12-page4.txt</td>
      <td>1872</td>
      <td>YI</td>
    </tr>
    <tr>
      <th>288596</th>
      <td>11540</td>
      <td>24</td>
      <td>0.000000</td>
      <td>jerusalem, thess, parable, lazarus, thou_hast,...</td>
      <td>YI18721201-V20-12-page5.txt</td>
      <td>1872</td>
      <td>YI</td>
    </tr>
    <tr>
      <th>288597</th>
      <td>11541</td>
      <td>24</td>
      <td>0.000000</td>
      <td>jerusalem, thess, parable, lazarus, thou_hast,...</td>
      <td>YI18721201-V20-12-page6.txt</td>
      <td>1872</td>
      <td>YI</td>
    </tr>
    <tr>
      <th>288598</th>
      <td>11542</td>
      <td>24</td>
      <td>0.012192</td>
      <td>jerusalem, thess, parable, lazarus, thou_hast,...</td>
      <td>YI18721201-V20-12-page7.txt</td>
      <td>1872</td>
      <td>YI</td>
    </tr>
    <tr>
      <th>288599</th>
      <td>11543</td>
      <td>24</td>
      <td>0.000000</td>
      <td>jerusalem, thess, parable, lazarus, thou_hast,...</td>
      <td>YI18721201-V20-12-page8.txt</td>
      <td>1872</td>
      <td>YI</td>
    </tr>
  </tbody>
</table>
<p>288600 rows × 7 columns</p>
</div>



# Data dictionary:

+ `index_pos` : Gensim uses the order in which the docs were streamed to link back the data and the source file. `index_pos` refers to the index id for the individual doc, which I used to link the resulting model information with the document name.
+ `topic_id` : The numerical id for each topic. For this model, I used 20 topics to classify the periodical pages.
+ `norm_topic_weight` : The proportion of the tokens in the document that are part of the topic, normalized per doc.
+ `topic_words` : The top 6 words in the topic.
+ `doc_id` : The file name of the document. The filename contains metadata information about the document, such as the periodical title, date of publication, volume, issue, and page number.
+ `year` : Year the document was published (according to the filename)
+ `title` : Periodical that the page was published in.

# Computing Topic Prevalence

The third approach I found for calculating topic significance over time is computing the topic prevalence. The primary example I found of this approach is Adrien Guille's TOM, [TOpic Modeling](http://mediamining.univ-lyon2.fr/people/guille/tom.php#about), library for Python. Rather than averaging the weights, his approach is to set a baseline for determining whether a topic is significantly present (in this case, it is the topic with the highest weight for a document) and then computing the percentage of documents in a given year where the topic is significantly present. 

Following the [pattern in the TOM library](https://github.com/AdrienGuille/TOM/blob/master/tom_lib/nlp/topic_model.py#L167-L183), we can compute the prevalence of the topics by identifying the topic with the highest weight per document, grouping the results by year, adding up the number of top occurrences of each topic per year and dividing by the total number of documents per year.


```python
# Group by document and take the row with max topic weight for each document
max_df = df[df.groupby(['index_pos'])['norm_topic_weight'].transform(max) == df['norm_topic_weight']]

# Group by year and topic, counting the number of documents per topic per year.
max_counts = max_df[['doc_id', 'year', 'topic_id']].groupby(['year', 'topic_id']).agg({'doc_id' : 'count'}).reset_index()
max_counts.columns = ['year', 'topic_id', 'max_count']
```


```python
# Count the number of individual documents per year
total_docs = max_df[['year', 'doc_id']].groupby('year').agg({'doc_id' : 'count'}).reset_index()
total_docs.columns = ['year', 'total_docs']
```


```python
# Combine the two dataframes
max_counts = max_counts.merge(total_docs, on='year', how='left')

# Create a new column with the count per topic divided by the total docs per year
max_counts['prevalence'] = max_counts['max_count']/max_counts['total_docs']

# Add the topic labels to make human-readable
max_counts = max_counts.merge(labels, on="topic_id")
```


```python
max_counts
```




<div>
<style>
    .dataframe {
        font-size: 12px;
    }
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>year</th>
      <th>topic_id</th>
      <th>max_count</th>
      <th>total_docs</th>
      <th>prevalence</th>
      <th>topic_words</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1859</td>
      <td>0</td>
      <td>90</td>
      <td>512</td>
      <td>0.175781</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1860</td>
      <td>0</td>
      <td>79</td>
      <td>512</td>
      <td>0.154297</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1861</td>
      <td>0</td>
      <td>79</td>
      <td>408</td>
      <td>0.193627</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1862</td>
      <td>0</td>
      <td>67</td>
      <td>514</td>
      <td>0.130350</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1863</td>
      <td>0</td>
      <td>59</td>
      <td>424</td>
      <td>0.139151</td>
      <td>satan, salvation, sinner, righteousness, peace...</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>352</th>
      <td>1867</td>
      <td>2</td>
      <td>1</td>
      <td>951</td>
      <td>0.001052</td>
      <td>animal, fruit, horse, flesh, sheep, gardner</td>
    </tr>
    <tr>
      <th>353</th>
      <td>1872</td>
      <td>2</td>
      <td>7</td>
      <td>904</td>
      <td>0.007743</td>
      <td>animal, fruit, horse, flesh, sheep, gardner</td>
    </tr>
    <tr>
      <th>354</th>
      <td>1874</td>
      <td>2</td>
      <td>3</td>
      <td>883</td>
      <td>0.003398</td>
      <td>animal, fruit, horse, flesh, sheep, gardner</td>
    </tr>
    <tr>
      <th>355</th>
      <td>1869</td>
      <td>16</td>
      <td>3</td>
      <td>682</td>
      <td>0.004399</td>
      <td>association, publishing, chart, dollar, xxii, ...</td>
    </tr>
    <tr>
      <th>356</th>
      <td>1872</td>
      <td>16</td>
      <td>1</td>
      <td>904</td>
      <td>0.001106</td>
      <td>association, publishing, chart, dollar, xxii, ...</td>
    </tr>
  </tbody>
</table>
<p>357 rows × 6 columns</p>
</div>




```python
# Limit to our 5 test topics
mc_s = max_counts[(max_counts['topic_id'] >= 15) & (max_counts['topic_id'] <= 20)]
```


```python
create_plotpoint(mc_s, 'prevalence', hue='topic_words',
                 title='Percentage of documents where topic is most significant per year'
                )
```




    <seaborn.axisgrid.FacetGrid at 0x114eebf98>

{% include image.html name="output_24_1.png" description="" %}

If we look back at our chart of the average topic weights per year, we can see that the two sets of lines are similar, but not the same. If we rely on prevalence, we see a larger spike of interest in health in 1867, in terms of pages dedicated to the topic. We also see more dramatic spikes in our topic on "mother, wife, told, went, young, school." 


```python
create_plotpoint(df, 'norm_topic_weight', hue='topic_words',
                 title='Central range of topic weights by year.'
                )
```




    <seaborn.axisgrid.FacetGrid at 0x1154bc400>

{% include image.html name="output_26_1.png" description="" %}

While not apparent from the data discussed here, the spikes in "mother, wife, told, went, young, school" correspond with the years where *The Youth's Instructor* is part of the corpus (1859, 1860, 1862, 1870, 1871, 1872). While the topic is clearly capturing language that occurs in multiple publications, the presence or absence of the title has a noticeable effect. We can use smoothing to adjust for the missing data (if we're interested in the overall trajectory of the topic), or use the information to frame our exploration what the topic is capturing.

---

*You can download and run the code locally using the [Jupyter Notebook version of this post](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/blogPosts/Calculating%20and%20Visualizing%20Topic%20Significance%20over%20Time%2C%20Part%203.ipynb)*



