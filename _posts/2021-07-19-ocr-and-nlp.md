---
layout: post
title: "Examining the Effects of OCR errors on NLP tasks"
tags: digital, research
published: false
excerpt_separator: <!--more-->
---

*I am presenting this research at the ACH conference on July 23rd.* 

## Origins 

Hi everyone. Thank you so much for being here and staying to the very end. I will try to keep this fun and light. 

I am Jeri Wieringa, I am an assistant professor in the department of religious studies at the university fo alabama, and I am a historican of American Religion. My work is focused on what are referred to as new religious movements and the interaction between gender norms, technology, and religious beliefs during their early development, and at the use of computational methods to study things like religion, culture, and identity. 

In my current reserach I am looking at Seventh-day Adventism, a religious movement that developed during the middle of the 19th century and is distinguished by their beliefs about the second coming and their incorporation of nineteenth-century health reform and vegetarianism into their religious system. The early Seventh-day Adventists were also a highly prolific group, using print as one of their core technologies for prosleytizing, or bringing new members into the fold. That emphasis on their written words continues into the present with an embrace of digital media and the internet for dissemination - the Seventh-day Adventists have committed significant resources toward digitizing their historical materials and making the available online. 

The centrality of print and the abundance of digital materials makes the SDA a prime candidate for analysis using computational methods, as well as a test case for exploring issues of OCR and data creation off of the beaten path of the major databases and digital archives. These materials have been digitized by volunteer and enthusiasts as well as denominational professionals over the last 3 decades, with varying technologies. On the whole, the OCR is remarkably good. I have estimated that, after some agressive automated correcting, the percentage of tokens that are recognizable as "words" to a subject appropriate dictionary is between 85% and 98% for the major titles.

What I want to talk about today, however, is the less good OCR, and particularly issues of layout recognition, which as far as I can tell, receives less attention in the research on OCR errors (where character recognition errors are more commonly discussed.)

I realized very quickly on in my dissertation research that, even though I could automate correcting character errors and the resulting spelling mistakes, the generated text files were largely illegible because of errors in layout recognition. As a result, I focused during the research on using algorithms that treat text as a bag of words, as the OCR literally left my text in that form. 

But the question has remained of what effects the different kinds of OCR errors have on the use of a range of natural langauge processing tools, including part of speech and entity recognition and tokenization, as well as on more complex processes such as abstractive summarization made possible by the development of large language models.

So the question that has been bothering me since I started working with the SDA literature is, how much of a difference do the errors in layout recognition make on the outputs of natural language processing tasks? 

## Existing Research

I am of course not the only person interested in the problem, and I am relying on the research of Daniel van Strien et.al., with the British Library and the Turing institute; as well as Smith and Cordell's 2018 report and research agenda on historical and multilingual OCR. In particular, van Strien's research uses the OverProof data from Trove (with is the Australian National Digital Library) to generate stastical data on the effects of OCR errors on NLP tasks. In their 2020 paper, the team demonstrates that the prevalence of OCR errors measurable affected the performance of sentence segmentation, named entity recognition (and particularly identifying of "GeoPolitical Entities), dependency parsing (where they found that the longer the dependency (the more words inbetween), the greater the effect of OCR errors on the performance.). Additionally, the team looked at retrieval and topic modeling tasks. For retrieval tasks, the messy data returned fewer "hits" and more false positivies, indicating a negative effect of the errors. In the topic modeling case, the topics still appeared coherent, but increasingly diverged from those generated from cleaned text as the OCR quality declined.

Similar to that of van Strien, et.al., my research connects to the first recommendation of Smith and Cordell's "Research Agenda," which calls for improved statistical analysis of OCR output. However, I am currently working independently on this question and so rather than attempt to construct a large dataset and show patterns at scale, I am focusing today on highlighting the different sorts of OCR challenges that are common in the OCRs of the SDA periodicals and showing how the results from a few standard NLP algorithm vary when given the OCR vs cleaned data. Here I am relying on van Strien's research to claim that OCR errors, particularly when they account for over 30% of the tokens in a document, do cause a measurable degredation of natural language processing algorithms. What I am showing here are examples of how different types of OCR errors cause different sorts of behaviors, even when the "true word" percentage is over that 70% threshold.

I also want to note that I am using "off the shelf" tools with no customization or fine-tuning.

## Types of OCR Errors in Data

My research uses a subset of the available periodicals that includes over 13,000 periodical issues. These I split into over 197,000 single page documents, and am dealing with each page as a unit. (Often when dealing with infromation from a large database, the content will be split on the article, which creates more coherent documents, but was not easy for me to automate with these particular pieces.)

In my work with the SDA periodicals, I found that the OCR generated from the scanned pages tend to fall into one of four categories:

1. Highly Accurate : with a few exceptions, the columns are correctly identified and nearly all of the words are correct, with minimal additional punctuation.
2. Minor Layout Issues : most of the words are correctly identified, but sections of the text are out of order.
3. Major Layout Recognition Issues : the text has not been split into columns appropriately, resulting in intersperse 5-10 word chunks. Particularly a problem for words split at the column break.
4. Major Character Recognition Issues : errors in both character and layout recognition, with the result being the text is not intelligible.

In addition, there are documents where discoloration or tearing of the original document results in sections of the text being lost. These documents will often have a higher error rate, but the text that does exist is in good shape.

Of these, using the standard extrinisic measurement of percentage of OCR words that have a corresponding dictionary entry, it is possible to recognize the files with major character recognition issues. Layout issues, by contrast, are harder to identify, because the words are largely "correct" but the order jumbled.

For this talk, I have selected an example of each of these four different types of OCR, and prepared a corresponding "ground-truth" file. These files come from four of the main periodicals produced by the denomination: The Review and Herald (highly accurate), the Youth's Instructor (minor layout errors), Signs of the Times (major layout errors), and The Health Reformer (major character recognition errors).

## Tests Run

I choose the following tasks to see how different NLP methods would work with the different types of documents. 

- similarity measures
- sentence tokenization (NLTK)
- entity recognition (SpaCY)
- part of speech tagging (SpaCy)
- summarization (BART / GPT2)
- text reuse (Passim)

Given the constraints of the talk, I want to highlight a few of the results I achieved. Overall, the results from the "major errors" document (Health Reformer) match the patterns described in van Strien, et.al.'s, research, where there is a significant divergence between the OCR and "ground-truth" results. The results from the two "layout" error documents, however, is less clear cut and that is where I want to focus attention today.

## Expected Results


- sentence tokenization
Overall, the number and length of sentences did not vary greatly between the texts with layout errors and their corresponding ground truths, the text with major errors of both characters and layout returned nearly double the number of sentences, with a smaller mean sentence length. (by contrast, the text with major layout issues had similar numbers of sentences, but a much higher max sentence length.)

- part of speech tagging with Spacy

Part of speech tagging worked as expected. Looking at the distribution of tags, there is some variation particularly in Nouns and Proper Nouns between the OCR generated and the ground-truth document in all cases of layout issues, but the shift is 10-20 words rather than the 100 word shift in the Health Reformer.

In the high error text (HR), the divergence between words tagged between the OCR and ground truth texts is striking. Notice the prevalence of 1-2 character words and clearly jumbled letters in the OCR-generated text. 

By contrast, in the high quality OCR test (RH), there are very few words from the ground truth not also in the OCRed text, and the additional words in the OCR document are largely OCR or line-ending errors.

This is also the case for documents where the columns were incorrectly identified. Most of the tokens "unique" to the OCRed text are clearly OCR errors or are fragments from a line ending that could not be reconnected. These fragments are one of the most noticeable indicators of issues in column recognition. One of the challenges of this sort of error is that it can result in "real" words that are the opposite of what was in the original text. For example, in the RT page, the OCR-only list includes "obedience" as a unique word in that set, where the word in the corrected text is "disobedience." While the part of speech is correctly assigned, the word used in future tasks is significantly different (and not easy to catch without comparison to a ground-truth).

- entity recognition
    - for HR, a lot of non-sensical tags
Similarly, 

- summarization

## Unexpected Results

- similarity measure

One thing I wanted to see is whether there would be a difference in similarity measures between documents when compared first as "bags of words" and second as vectors. The bag of words representation, unsurprisingly, showed the high error text as signficantly more dissimilar (65%), where the other three documents were computed to be 95% and 98% similar to their ground truth text.

Using a vector representation, some difference between the other three documents adn their ground truths begins to be captured. 


- entity recognition
    - RH - Annie R. Smith not tagged in either version (this is no longer the case with the medium sized model)


- text reuse
    - handled the split lines quite well. 
    - however, only a fraction of the included quotes captured

I also used Passim (thanks to Programming Historian) to see whether the column errors would cause problems for detecting text reuse - in this case, scripture quotations. Where it did detect quotes (and there were many to choose from,) the additional words in the OCRed text were brought along for the ride. Additionally, particularly in the ST text, the identified quotations were often only found in the OCR or the corrected text, but not in both. 

However, of the many quotes in the text, only a few were identified at all. This 

YI - 1/2
RH - 2/6
HR - 0/0
ST (both) - 2/14
ST (OCR) - 3
ST (GT) - 2
ST (tot) - 7/14


- summarization
One final experiment I did was to run summarization algorithms using the language models in BART and 

## On using off-the-shelf NLP tools

- abstractive summarization resulting in URLs added to text
    - as we think about how to use these large language models, do need to develop standard methods for fine-tuning them, 
- page segmentation for more abstract tasks.

## Conclusions and Future Directions

- need ways to identify documents that have failures of layout recognition.
- need collections of subject appropriate corrected text for fine-tuning existing algorithms. 
- we need some good data for training and fine-tuning
- even with good data, off the shelf tools and algorithms are insufficient 
- many tools, even those based on large language models, seem to performs similarily regardless of word order. However, as recent paper is suggesting, this may indicate that the algorithm does not "understand" language quite as well as it seems.
    - https://arxiv.org/abs/2012.15180
