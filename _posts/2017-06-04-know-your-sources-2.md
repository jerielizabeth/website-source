---
layout: post
title: "Know Your Sources (Part 2)"
tags: digital, research, dissertation

---

*This is [part of a series](http://jeriwieringa.com/portfolio/dissertation/) of technical essays documenting the computational analysis that undergirds my dissertation,* A Gospel of Health and Salvation. *For an overview of the dissertation project, you can read the [current project description](http://jeriwieringa.com/2017/04/21/updated-dissertation-description) at [jeriwieringa.com](http://jeriwieringa.com). You can access the Jupyter notebooks on [Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks).* 

*My goals in sharing the notebooks and technical essays are three-fold. First, I hope that they might prove useful to others interested in taking on similar projects. In these notebooks I describe and model how to approach a large corpus of sources and to use that corpus in the production of historical scholarship.* 

*Second, I am sharing them in hopes that "[given enough eyeballs, all bugs are shallow](https://en.wikipedia.org/wiki/Linus%27s_Law )." If you encounter any bugs, if you see an alternative way to solve a problem, or if the code does not achieve the goals I have set out for it, please let me know!*

*Third, these notebooks make an argument for methodological transparency and for the discussion of methods as part of the scholarly output of digital history. Often the technical work in digital history is done behind the scenes, with publications favoring the final research products, usually in article form with interesting visualizations. While there is a growing culture in digital history of releasing source code, there is little discussion of how that code was developed -- the impulse is to move on once the code "works" and to focus in the presentation on what that code produced, without attending to why a solution was chosen and what that solution both enables and prevents. These notebooks seek to serve that middle space between code and the final analysis - documenting the computational problem solving that I've done on the way to the analysis. As these essays attest, each step in the processing of the corpus requires the researcher to make a myriad of distinctions about the world they seek to model, decisions that shape the outcomes of the computational analysis and are part of the historical argument of the work.*

---

So far in this series I have discussed [gathering a collection of texts](http://jeriwieringa.com/2017/04/25/gathering-sources/), [extracting the text](http://jeriwieringa.com/2017/04/27/Extract-Text-from-PDFs/), and [identifying the coverage](http://jeriwieringa.com/2017/05/05/know-your-sources-1/) of the corpus. My next step is to assess the quality of the source base. 

Because I am interested in problems of categorization and discourse, it is important that I have a mechanism to verify that the text layer provides a sufficiently accurate representation of the original print. While processes such as keyword search or computing document similarity can be performed so as to be resilient to OCR errors, an abundance of errors in the text used in topic modeling would make the topic models unreliable for identifying documents and for surfacing patterns of discourse.[^4] Without some external information against which to compare the text, it is impossible to know what the overall "health" of the corpus is, to identify what steps need to be taken to improve the quality of the text, and to determine whether the steps I take are effective.

Unlike the newspapers digitized by the *[Chronicling America](http://chroniclingamerica.loc.gov/)* project, which are encouraged to include "confidence level data" in the OCR data by the Library of Congress guidelines,[^1] the interface provided by the SDA provides very little information about the processes by which the periodicals were digitized and the expected quality of the OCR. As a result, the quality of the resulting text layers is obscured. A brief glance through the resulting text files suggests that OCR is of average quality -- good enough to be legible but with enough errors to raise concerns. At the same time, the age of the periodicals and the idiosyncrasies of 19th century typography and layout suggest that these documents contain sections that were likely a challenge for the OCR engine.

There are two general methods for evaluating the accuracy of transcribed textual data: comparison of the generated text to some "ground truth" (text that is known to be accurate) or comparison of the generated text to a bank of known words.

The first method is used by Simon Tanner, Trevor Muñoz, and Pich Hemy Ros in their evaluation of the OCR quality of the British Library's 19th Century Online Newspaper Archive. Working with a sample of 1% of the 2 million pages digitized by the British Library, the team calculated the highest rates of OCR accuracy achieved by comparing the generated XML text to a "double re-keyed" ground-truth version.[^2] Having a verified ground-truth document enabled the team to provide accurate results about the quality of generated texts (which were generally disappointing, particularly for proper nouns and "significant" or content words). Their approach, however, is labor and time intensive -- more than can be taken on by most individual scholars with limited financial resources.

The second approach, which the *[Mapping Texts](http://mappingtexts.org/)* team used for their analysis of the OCR accuracy of the Texas newspapers in *[Chronicling America](http://chroniclingamerica.loc.gov/)*, is to compare the generated text to an authoritative wordlist and compute the number of words outside the approved set.[^6] This approach is easier to implement, as it takes much less time to compile a list of relevant words than to re-key even a 1% sample of the text. However, the results are less accurate. The method is blind to places where the OCR engine produced a word that, while in the wordlist, does not match the text on the page or where spelling variations that occur on the page are flagged as OCR errors because they are not included in the word list. Because of the possibility of both false positives and false negatives, the results are an approximate representation of the accuracy of the OCR.

Weighing the disadvantages of both approaches, I chose to use the second method, comparing the generated OCR to an authoritative wordlist. This method was the most practical for me to implement within the constraints of the dissertation. In addition, a bank of subject appropriate words has utility for automated spelling correction, as is suggested in the research of Thomas Lasko and Susan Hauser on methods for OCR correction of the text from the National Library of Medicine.[^5] These factors shaped my decision to evaluate the quality of the extracted text by comparing it to an external word list.

[^1]: “The National Digital Newspaper Program (NDNP) Technical Guidelines for Applicants.” *Library of Congress* (2016): p. 11. [http://www.loc.gov/ndnp/guidelines/NDNP_201517TechNotes.pdf](http://www.loc.gov/ndnp/guidelines/NDNP_201517TechNotes.pdf)

[^2]: Tanner, Simon, Trevor Muñoz, and Pich Hemy Ros. “Measuring Mass Text Digitization Quality and Usefulness: Lessons Learned From Assessing the OCR Accuracy of the British Library’s 19th Century Online Newspaper Archive.” *D-Lib Magazine* 15, no. 7/8 (2009): §5. doi: [http://dx.doi.org/10.1045/july2009-munoz](http://dx.doi.org/10.1045/july2009-munoz)

[^4]: Recent studies on text reuse have effectively used ngram comparison to find reuse despite differences attributable to errors in character recognition or minor editorial rephrasing. (See Mullen (2016), [http://americaspublicbible.org/methods.html](http://americaspublicbible.org/methods.html) and Smith, Cordell, Dillon (2013), “Infectious Texts: Modeling Text Reuse in Nineteenth-Century Newspapers,” *2013 IEEE International Conference on Big Data*. doi: [http://dx.doi.org/10.1109/BigData.2013.6691675](http://dx.doi.org/10.1109/BigData.2013.6691675)) However, research in the field of information retrieval has found that algorithms that factor the relative prevalence of words in a corpus are negatively effected by high OCR rates. (See Taghva, Kazem, Thomas Nartker, and Julie Borsack. “Information Access in the Presence of OCR Errors.” <I>Proceedings of the 1st ACM workshop on Hardcopy document processing</I> the 1st ACM workshop (2004): 1–8. doi: [http://dx.doi.org/10.1145/1031442.1031443](http://dx.doi.org/10.1145/1031442.1031443)). 

[^5]: Lasko, Thomas A., and Susan E. Hauser. “Approximate String Matching Algorithms for Limited-Vocabulary OCR Output Correction.” <I>Proceedings of SPIE</I> 4307 (2001): 232–40. doi: [http://dx.doi.org/10.1117/12.410841](http://dx.doi.org/10.1117/12.410841)

[^6]: Torget, Andrew J., Mihalcea, Rada, Christensen, Jon, and McGhee, Geoff. “Mapping Texts: Combining Text-Mining and Geo-Visualization to Unlock the Research Potential of Historical Newspapers.” <I>Mapping Texts</I> (2011): Accessed March 29, 2017. [http://mappingtexts.org/whitepaper/MappingTexts_WhitePaper.pdf](http://mappingtexts.org/whitepaper/MappingTexts_WhitePaper.pdf).


# NLTK 'words' Corpus

My first choice of wordlists was the NLTK `words.words` list, as this is a standard word bank used in many projects. The first stop for documentation on published datasets, including wordlists, is the included README file. The README file at the base of the NLTK words corpus contains the following sparse lines: 

>Wordlists
>
>en: English, http://en.wikipedia.org/wiki/Words_(Unix)
>en-basic: 850 English words: C.K. Ogden in The ABC of Basic English (1932)

The linked Wikipedia article contains only a little more information:

>words is a standard file on all Unix and Unix-like operating systems, and is simply a newline-delimited list of dictionary words. It is used, for instance, by spell-checking programs.[1]
>
>The words file is usually stored in /usr/share/dict/words or /usr/dict/words.
>
>On Debian and Ubuntu, the words file is provided by the wordlist package, or its provider packages wbritish, wamerican, etc. On Fedora and Arch, the words file is provided by the words package.

Fortunately, my personal computer runs on a "Unix-like" operating system, so I was able to gather the following additional information from the README in the suggested `/usr/dict/words` directory. 

>Welcome to web2 (Webster's Second International) all 234,936 words worth.
The 1934 copyright has lapsed, according to the supplier.  The
supplemental 'web2a' list contains hyphenated terms as well as assorted
noun and adverbial phrases. 

Here at last we have information about the source of the collection of words so frequently used for American English spell-checking programs. However, it is not clear whether or not this is the correct file, as the original link also referenced the wordlist packages in Debian and Ubuntu systems. To confirm that NLTK is using the list of words derived from Webster's Second International Dictionary, I used set comparison to identify the overlap between the two lists.

## Comparing NTLK `words` to `web2`


```python
''' You may receive an error message noting that you need to download the words corpus from NTLK. 
Follow the instructions in the error message and then rerun the cell.
'''
from nltk.corpus import words
```


```python
# Function for pulling words from a txt file
def load_from_txt(file_name):
    with open(file_name, "r") as txt:
        words = txt.read().splitlines()
    return(words)
```


```python
nltk_list = [w for w in words.words()]
```

We can get an overview of the list by examining the number of words, and printing out the first 10.


```python
len(set(nltk_list))
```




    235892




```python
nltk_list[:10]
```




    ['A',
     'a',
     'aa',
     'aal',
     'aalii',
     'aam',
     'Aani',
     'aardvark',
     'aardwolf',
     'Aaron']




```python
web2_list = load_from_txt('/usr/share/dict/web2')
```


```python
len(set(web2_list))
```




    235886




```python
web2_list[:10]
```




    ['A',
     'a',
     'aa',
     'aal',
     'aalii',
     'aam',
     'Aani',
     'aardvark',
     'aardwolf',
     'Aaron']



At this point, it seems likely that the two lists are similar, though not quite identical. To identify the differences, I used set comparison to quickly reveal where the list do not overlap.


```python
'''Use set().symmetric_difference(set()) to return the list of items that are in either list,
but not in both lists. This provides a quick snapshot of the discontinuities between the two lists.
See https://docs.python.org/3.5/library/stdtypes.html#set-types-set-frozenset for more details. 
'''
set(nltk_list).symmetric_difference(set(web2_list))
```




    {'behaviour', 'box', 'colour', 'harbour', 'humour', 'near'}



These results indicate that, with the exceptions of a few British spellings and the curious case of "box" and "near", the two lists are functionally identical.

## Evaluate Corpus Docs with NLTK 'words' (web2)

Armed with the knowledge that the NLKT wordlist is, in fact, the words from Webster's Second International Dictionary, I moved next to evaluate how well the wordlist covers the vocabulary of our corpus. To do that, I read in one of the documents, did some minimal cleaning, and then found the disjoin between the corpus words and the NLTK wordlist.


```python
from nltk import word_tokenize
from nltk.tokenize import WhitespaceTokenizer
from os import path
import re
```


```python
def readfile( input_dir, filename ):
    """Reads in file from directory and file name.
    Returns the content of the file.

    Usage::

        >>> text = readfile(input_dir, filename)

    Args:
        input_dir (str): Directory with the input file.
        filename (str): Name of file to be read.

    Returns:
        str: Returns the content of the file as a string.

    """
    with open(path.join(input_dir, filename)) as f:
        return f.read()


def strip_punct( text ):
    """Remove punctuation and numbers.
    Remove select punctuation marks and numbers from a text and replaces them with a space.
    
    Non-permanent changes for evaluation purposes only.
    
    Uses the :mod:`re` library.

    Args:
        text (str): Content to be evaluated.

    Returns:
        str: Returns the content string without the following characters: 0-9,.!?$:;&".
    """
    text_cleaned = re.sub(r"[0-9,.!?$:;&\"]", " ", text)
    
    return text_cleaned


def tokenize_text( text, tokenizer='whitespace' ):
    """Converts file content to a list of tokens. 

    Uses :meth:`nltk.tokenize.regexp.WhitespaceTokenizer`.

    Args:
        text (str): Content to be tokenized.
        tokenizer(str): option of tokenizer. Current options are 'whitespace' and
            'word'.

    Returns:
        list: Returns a list of the tokens in the text, separated by white space.
    """
    if tokenizer == 'whitespace' or tokenizer == 'word':
        if tokenizer == 'whitespace':
            return WhitespaceTokenizer().tokenize(text)
        elif tokenizer == 'word':
            return word_tokenize(text)
    else:
        raise ValueError('Tokenizer value {} is invalid. Must be "whitespace" or "word"'.format(tokenizer))


def to_lower( tokens ):
    """Convert all tokens to lower case.

    Args:
        tokens (list): List of tokens generated using a tokenizer.

    Returns:
        list: List of all tokens converted to lowercase.
    """
    return [w.lower() for w in tokens]


def identify_errors( tokens, dictionary ):
    """Compare words in documents to words in dictionary. 

    Args:
        tokens (list): List of all tokens in the document.
        dictionary (set): The set of approved words.
        
    Returns:
        set : Returns the set of tokens that are not 
            also dictionary words.
    """
    return set(tokens).difference(dictionary)


def create_spelling_dictionary( directory, wordlists ):
    """Compile a spelling dictionary.
    Compiles a spelling dictionary from one or multiple
    wordlist files. Returns results as a set.

    Args:
        directory (str): Location of the wordlist files.
        wordlists (list): List of filenames for the wordlist files.

    Returns:
        set: List of unique words in all the compiled lists.
    """
    spelling_dictionary = []
    for wordlist in wordlists:
        words = readfile(directory, wordlist).splitlines()
        word_list = [w.lower() for w in words]
        for each in word_list:
            spelling_dictionary.append(each)

    return set(spelling_dictionary)


def get_doc_errors( input_dir, filename, dictionary ):
    """Identify words in text that are not in a dictionary set.
    
    Args:
        input_dir (str): Directory containing text files
        filename (str): Name of file to evaluate
        dictionary (set): Set of verified words
    Returns:
        set: Returns set of words in doc that are not in the dictionary.
    """
    text = strip_punct(readfile(input_dir, filename))
    tokens = to_lower(tokenize_text(text, tokenizer='whitespace'))
    return identify_errors(tokens, dictionary)
```


```python
input_dir = "data/"
filename = "HR18910601-V26-06-page34.txt"
```

First, because previewing early and often is key to evaluating the effectiveness of the code, I start by printing out the file content as well as the cleaned and tokenized version of the text. Overall, the OCR quality is good. There are a number of line-ending problems and some rogue characters, but the content and general message of the page is very legible. 


```python
readfile(input_dir, filename)
```




    ' THE LEGUMINOUS SEEDS.\nAbstract of a lesson in cookery given by Mrs. E. E. Kellogg, to the Health and Temperance Training Class.]\nTHE leguminous seeds, or legumes, are those foods better known as peas, beans, and lentils. They are usually served as vegetables, but are very different in their composition, as they contain in their mature state a large excess of the nitrogenous element, while the ordinary vegetables are quite lacking in this important element. In their immature state the legumes are more similar to vegetables. Dried peas are found in the market in two different forms, the green, or Scotch peas, and those which have been divided and the skins removed, called split peas. There are also several varieties of lentils to be found in market. Lentils are somewhat superior to peas or beans in nutritive value, but people usually dislike their taste until they have become used to them.\nThe different varieties of beans vary but little as to nutritive value. The Lima bean is more delicate in flavor, and is generally looked upon with most favor. The Chinese and Japanese make large use of the leguminous foods. They have a kind of bean known as soja, which is almost entirely composed of nitroge- nous material. Peas and beans contain caseine, which is similar in its characteristics to the caseine of milk. The Chinese take advantage of this fact, and manu- facture a kind of cheese from them.\nThe legumes are all extensively used in India, China, Japan, and other Eastern countries. Com- bined with rice, which is used as a staple article of diet in these countries, and which contains an excess of the carbonaceous element, they form an excellent food. In England, peas are largely used by persons who are in training as athletes, because they are con- sidered to be superior strength producers.,\nAlthough these seeds are in themselves such nutri- tious food, they are in this country commonly prepared in some manner which renders them indigestible. Beans, especially, are used in connec- tion with a large amount of fat, and are not, in\ngeneral, properly cooked. Peas and beans are covered with a tough skin, and require a prolonged cooking, in order to soften them. If, in cooking, this skin is left intact, and not broken afterward by careful mastication, the legume may pass through the di- gestive tract without being acted upon by the digestive fluids. Even prolonged cooking will not render the skin digestible. It is best that we prepare these seeds in such a manner that the skins may be rejected. When used with the skins a large per- centage of the nutritive material is wasted, since it is impossible for the digestive processes to free it from the skins.\nIn preparing them for cooking, it is generally best to soak them over night. The soaking aids the process of cooking, and to some extent does away with the strong flavor which to some people is very disagreeable. Soft water is best for cooking all dried seeds. If dry peas or beans are put into hard, boiling water, they will not soften, because the min- eral element of the water acts upon the caseine to harden it. As to the quantity needed, much depends upon the degree of heat used, but in general two quarts of soft water will be quite sufficient for one pint of seeds.\nMASHED PEAS.Ñ Cook one quart of dried Scotch peas until tender, simmering slowly at the last so that the water will be nearly or quite evaporated. Then rub them through a colander, or vegetable press. Add to the sifted peas one half cup of good sweet cream, and salt if desired. Pour into a granite or earthen dish, and put into the oven to brown. Some prefer it browned until mealy, some prefer it rather moist. This same dish can be made with split peas by simply mashing them.\nBrans may likewise be put through the same proc- ess. This is one of the most digestible forms in which they can be prepared.\n( I9o)\n'




```python
to_lower(tokenize_text(strip_punct(readfile(input_dir, filename))))
```




    ['the',
     'leguminous',
     'seeds',
     'abstract',
     'of',
     'a',
     'lesson',
     'in',
     'cookery',
     'given',
     'by',
     'mrs',
     'e',
     'e',
     'kellogg',
     'to',
     'the',
     'health',
     'and',
     'temperance',
     'training',
     'class',
     ']',
     'the',
     'leguminous',
     'seeds',
     'or',
     'legumes',
     'are',
     'those',
     'foods',
     'better',
     'known',
     'as',
     'peas',
     'beans',
     'and',
     'lentils',
     'they',
     'are',
     'usually',
     'served',
     'as',
     'vegetables',
     'but',
     'are',
     'very',
     'different',
     'in',
     'their',
     'composition',
     'as',
     'they',
     'contain',
     'in',
     'their',
     'mature',
     'state',
     'a',
     'large',
     'excess',
     'of',
     'the',
     'nitrogenous',
     'element',
     'while',
     'the',
     'ordinary',
     'vegetables',
     'are',
     'quite',
     'lacking',
     'in',
     'this',
     'important',
     'element',
     'in',
     'their',
     'immature',
     'state',
     'the',
     'legumes',
     'are',
     'more',
     'similar',
     'to',
     'vegetables',
     'dried',
     'peas',
     'are',
     'found',
     'in',
     'the',
     'market',
     'in',
     'two',
     'different',
     'forms',
     'the',
     'green',
     'or',
     'scotch',
     'peas',
     'and',
     'those',
     'which',
     'have',
     'been',
     'divided',
     'and',
     'the',
     'skins',
     'removed',
     'called',
     'split',
     'peas',
     'there',
     'are',
     'also',
     'several',
     'varieties',
     'of',
     'lentils',
     'to',
     'be',
     'found',
     'in',
     'market',
     'lentils',
     'are',
     'somewhat',
     'superior',
     'to',
     'peas',
     'or',
     'beans',
     'in',
     'nutritive',
     'value',
     'but',
     'people',
     'usually',
     'dislike',
     'their',
     'taste',
     'until',
     'they',
     'have',
     'become',
     'used',
     'to',
     'them',
     'the',
     'different',
     'varieties',
     'of',
     'beans',
     'vary',
     'but',
     'little',
     'as',
     'to',
     'nutritive',
     'value',
     'the',
     'lima',
     'bean',
     'is',
     'more',
     'delicate',
     'in',
     'flavor',
     'and',
     'is',
     'generally',
     'looked',
     'upon',
     'with',
     'most',
     'favor',
     'the',
     'chinese',
     'and',
     'japanese',
     'make',
     'large',
     'use',
     'of',
     'the',
     'leguminous',
     'foods',
     'they',
     'have',
     'a',
     'kind',
     'of',
     'bean',
     'known',
     'as',
     'soja',
     'which',
     'is',
     'almost',
     'entirely',
     'composed',
     'of',
     'nitroge-',
     'nous',
     'material',
     'peas',
     'and',
     'beans',
     'contain',
     'caseine',
     'which',
     'is',
     'similar',
     'in',
     'its',
     'characteristics',
     'to',
     'the',
     'caseine',
     'of',
     'milk',
     'the',
     'chinese',
     'take',
     'advantage',
     'of',
     'this',
     'fact',
     'and',
     'manu-',
     'facture',
     'a',
     'kind',
     'of',
     'cheese',
     'from',
     'them',
     'the',
     'legumes',
     'are',
     'all',
     'extensively',
     'used',
     'in',
     'india',
     'china',
     'japan',
     'and',
     'other',
     'eastern',
     'countries',
     'com-',
     'bined',
     'with',
     'rice',
     'which',
     'is',
     'used',
     'as',
     'a',
     'staple',
     'article',
     'of',
     'diet',
     'in',
     'these',
     'countries',
     'and',
     'which',
     'contains',
     'an',
     'excess',
     'of',
     'the',
     'carbonaceous',
     'element',
     'they',
     'form',
     'an',
     'excellent',
     'food',
     'in',
     'england',
     'peas',
     'are',
     'largely',
     'used',
     'by',
     'persons',
     'who',
     'are',
     'in',
     'training',
     'as',
     'athletes',
     'because',
     'they',
     'are',
     'con-',
     'sidered',
     'to',
     'be',
     'superior',
     'strength',
     'producers',
     'although',
     'these',
     'seeds',
     'are',
     'in',
     'themselves',
     'such',
     'nutri-',
     'tious',
     'food',
     'they',
     'are',
     'in',
     'this',
     'country',
     'commonly',
     'prepared',
     'in',
     'some',
     'manner',
     'which',
     'renders',
     'them',
     'indigestible',
     'beans',
     'especially',
     'are',
     'used',
     'in',
     'connec-',
     'tion',
     'with',
     'a',
     'large',
     'amount',
     'of',
     'fat',
     'and',
     'are',
     'not',
     'in',
     'general',
     'properly',
     'cooked',
     'peas',
     'and',
     'beans',
     'are',
     'covered',
     'with',
     'a',
     'tough',
     'skin',
     'and',
     'require',
     'a',
     'prolonged',
     'cooking',
     'in',
     'order',
     'to',
     'soften',
     'them',
     'if',
     'in',
     'cooking',
     'this',
     'skin',
     'is',
     'left',
     'intact',
     'and',
     'not',
     'broken',
     'afterward',
     'by',
     'careful',
     'mastication',
     'the',
     'legume',
     'may',
     'pass',
     'through',
     'the',
     'di-',
     'gestive',
     'tract',
     'without',
     'being',
     'acted',
     'upon',
     'by',
     'the',
     'digestive',
     'fluids',
     'even',
     'prolonged',
     'cooking',
     'will',
     'not',
     'render',
     'the',
     'skin',
     'digestible',
     'it',
     'is',
     'best',
     'that',
     'we',
     'prepare',
     'these',
     'seeds',
     'in',
     'such',
     'a',
     'manner',
     'that',
     'the',
     'skins',
     'may',
     'be',
     'rejected',
     'when',
     'used',
     'with',
     'the',
     'skins',
     'a',
     'large',
     'per-',
     'centage',
     'of',
     'the',
     'nutritive',
     'material',
     'is',
     'wasted',
     'since',
     'it',
     'is',
     'impossible',
     'for',
     'the',
     'digestive',
     'processes',
     'to',
     'free',
     'it',
     'from',
     'the',
     'skins',
     'in',
     'preparing',
     'them',
     'for',
     'cooking',
     'it',
     'is',
     'generally',
     'best',
     'to',
     'soak',
     'them',
     'over',
     'night',
     'the',
     'soaking',
     'aids',
     'the',
     'process',
     'of',
     'cooking',
     'and',
     'to',
     'some',
     'extent',
     'does',
     'away',
     'with',
     'the',
     'strong',
     'flavor',
     'which',
     'to',
     'some',
     'people',
     'is',
     'very',
     'disagreeable',
     'soft',
     'water',
     'is',
     'best',
     'for',
     'cooking',
     'all',
     'dried',
     'seeds',
     'if',
     'dry',
     'peas',
     'or',
     'beans',
     'are',
     'put',
     'into',
     'hard',
     'boiling',
     'water',
     'they',
     'will',
     'not',
     'soften',
     'because',
     'the',
     'min-',
     'eral',
     'element',
     'of',
     'the',
     'water',
     'acts',
     'upon',
     'the',
     'caseine',
     'to',
     'harden',
     'it',
     'as',
     'to',
     'the',
     'quantity',
     'needed',
     'much',
     'depends',
     'upon',
     'the',
     'degree',
     'of',
     'heat',
     'used',
     'but',
     'in',
     'general',
     'two',
     'quarts',
     'of',
     'soft',
     'water',
     'will',
     'be',
     'quite',
     'sufficient',
     'for',
     'one',
     'pint',
     'of',
     'seeds',
     'mashed',
     'peas',
     'ñ',
     'cook',
     'one',
     'quart',
     'of',
     'dried',
     'scotch',
     'peas',
     'until',
     'tender',
     'simmering',
     'slowly',
     'at',
     'the',
     'last',
     'so',
     'that',
     'the',
     'water',
     'will',
     'be',
     'nearly',
     'or',
     'quite',
     'evaporated',
     'then',
     'rub',
     'them',
     'through',
     'a',
     'colander',
     'or',
     'vegetable',
     'press',
     'add',
     'to',
     'the',
     'sifted',
     'peas',
     'one',
     'half',
     'cup',
     'of',
     'good',
     'sweet',
     'cream',
     'and',
     'salt',
     'if',
     'desired',
     'pour',
     'into',
     'a',
     'granite',
     'or',
     'earthen',
     'dish',
     'and',
     'put',
     'into',
     'the',
     'oven',
     'to',
     'brown',
     'some',
     'prefer',
     'it',
     'browned',
     'until',
     'mealy',
     'some',
     'prefer',
     'it',
     'rather',
     'moist',
     'this',
     'same',
     'dish',
     'can',
     'be',
     'made',
     'with',
     'split',
     'peas',
     'by',
     'simply',
     'mashing',
     'them',
     'brans',
     'may',
     'likewise',
     'be',
     'put',
     'through',
     'the',
     'same',
     'proc-',
     'ess',
     'this',
     'is',
     'one',
     'of',
     'the',
     'most',
     'digestible',
     'forms',
     'in',
     'which',
     'they',
     'can',
     'be',
     'prepared',
     '(',
     'i',
     'o)']



Comparing the text to the NLTK list, however, returns a number of "real" words identified as errors.


```python
get_doc_errors( input_dir, filename, set(to_lower(nltk_list)))
```




    {'(',
     ']',
     'acted',
     'aids',
     'athletes',
     'beans',
     'bined',
     'brans',
     'browned',
     'called',
     'caseine',
     'characteristics',
     'com-',
     'con-',
     'connec-',
     'contains',
     'cooked',
     'countries',
     'depends',
     'di-',
     'england',
     'evaporated',
     'fluids',
     'foods',
     'forms',
     'gestive',
     'kellogg',
     'lacking',
     'legumes',
     'lentils',
     'looked',
     'manu-',
     'mashed',
     'min-',
     'needed',
     'nitroge-',
     'nutri-',
     'o)',
     'peas',
     'per-',
     'persons',
     'preparing',
     'proc-',
     'processes',
     'producers',
     'prolonged',
     'quarts',
     'rejected',
     'renders',
     'seeds',
     'served',
     'sidered',
     'simmering',
     'skins',
     'tion',
     'tious',
     'varieties',
     'vegetables',
     'ñ'}



With words such as "vegetables" and "cooked" missing from the NLTK wordlist, it is clear that this list is insufficient for computing the ratio of words to errors in the documents.

## SCOWL (Spell Checker Oriented Word Lists)

With the default Unix wordlist insufficient as a base for evaluating the corpus, I looked next at the [`wordlist` package included with Ubuntu](http://packages.ubuntu.com/precise/wamerican), which is also mentioned in the Wikipedia entry for [`words`](http://en.wikipedia.org/wiki/Words_(Unix)). This package links out to the [SCOWL (Spell Checker Oriented Word Lists) project](http://wordlist.aspell.net/).[^3] Rather than use one of the provided word lists, I used the [web application](http://app.aspell.net/create) to create a custom a list. I used the following parameters, as documented in the [README]('data/SCOWL-wl/README'):

+ diacritic: keep
+ max_size: 70
+ max_variant: 1
+ special: roman-numerals
+ spelling: US GBs

These parameters provide a wordlist that includes both American and British spellings, including common variant spellings. `max_size` of "70" refers to the "large" collection of words which are contained in most dictionaries, and which is, according to the author, the largest recommended set for spelling, while the larger "80" and "95" sets  contain obscure and questionable words. 

[^3]: Atkinson, Kevin. "Spell Checking Oriented Word Lists (Scowl)." (2016): Accessed Nov 18, 2016. [http://wordlist.aspell.net/scowl-readme/](http://wordlist.aspell.net/scowl-readme/).


```python
scowl = load_from_txt('data/SCOWL-wl/words.txt')
```


```python
len(set(scowl))
```




    171131




```python
scowl[:10]
```




    ['A', "A's", 'AA', "AA's", 'AAA', 'AAM', 'AB', "AB's", 'ABA', 'ABC']



When we compare the difference between the two lists, we can see that the majority of words in the SCOWL list are not in the NLTK words list.


```python
len(set(scowl).difference(set(nltk_list)))
```




    104524



And when we can run the file content through our error checking function, we get results that are much closer to what we would expect.


```python
get_doc_errors( input_dir, filename, set(to_lower(scowl)))
```




    {'(',
     ']',
     'bined',
     'brans',
     'caseine',
     'centage',
     'com-',
     'con-',
     'connec-',
     'di-',
     'eral',
     'ess',
     'gestive',
     'manu-',
     'min-',
     'nitroge-',
     'nutri-',
     'o)',
     'per-',
     'proc-',
     'sidered',
     'soja',
     'tion',
     'tious',
     'ñ'}



## Filtering the SCOWL List

While it may seem valuable to have an all-encompassing list, one that contains all possible words, a list that is too expansive is actually detrimental to the task of identifying OCR errors. Unusual words, or single letters, are more likely to be the result of a transcription error than an intentional choice by the author or editor, but an overly expansive wordlist would capture these as "words," thus under-reporting the transcription errors. In constructing the word list, I am looking to strike a delicate balance between false negatives (words identified as errors, but are words) and false positives (words that are identified as words, but are errors). 

The SCOWL list contains a few elements that increase the risk of false positive identification. First, the list contains a collection of abbreviations, which are mostly 20th-century in origin and which, once converted to lowercase for comparison, are unlikely to match any of the content produced by the SDA authors. 

Second, one of the lists used in the SCOWL application includes the letter section headers as words, so instances of any single letter, such as "e", are identified as a word. Two of the most frequent problems in the OCR text are words that are "burst" words, or words where a space has been inserted between each of the letters (I N S T R U C T O R), and words that have been split due to line endings (di- gestion). As a result, a number of the errors will appear in the form of individual letters and two letter words. In order to capture these transcription errors, the wordlist needs to be particularly conservative with regard to single-letter and two-letter words. 

To improve my ability to capture these errors, I filtered out the acronyms and all words less than 3 characters in length from the SCOWL list. I added back common words, such as "I", "in", and "be," through the subject-specific lists, which I cover below. 


```python
# Using regex to remove all abbreviations and their possessive forms
s_filtered = [x for x in scowl if not re.search(r"\b[A-Z]{1,}'s\b|\b[A-Z]{1,}\b", x)]
```


```python
s_filtered[:10]
```




    ['ABCs',
     'ABMs',
     'Aachen',
     "Aachen's",
     'Aalborg',
     'Aalesund',
     'Aaliyah',
     "Aaliyah's",
     'Aalst',
     "Aalst's"]




```python
s_filtered = [x for x in s_filtered if len(x) > 2]
```

To ensure that I have not removed too many words, I preview the error report once again.


```python
get_doc_errors( input_dir, filename, set(to_lower(s_filtered)))
```




    {'(',
     ']',
     'a',
     'an',
     'as',
     'at',
     'be',
     'bined',
     'brans',
     'by',
     'caseine',
     'centage',
     'com-',
     'con-',
     'connec-',
     'di-',
     'e',
     'eral',
     'ess',
     'gestive',
     'i',
     'if',
     'in',
     'is',
     'it',
     'manu-',
     'min-',
     'nitroge-',
     'nutri-',
     'o)',
     'of',
     'or',
     'per-',
     'proc-',
     'sidered',
     'so',
     'soja',
     'tion',
     'tious',
     'to',
     'we',
     'ñ'}



These results are what I expected. There are a number of additional two-letter "errors" but otherwise the list appears unchanged.

I then saved the filtered word list to the data folder for later use.

# Adding subject-specific words

The SCOWL wordlist provides a broad base of English language words against which to compare the words identified in the SDA periodicals. We could proceed with just this list, but that strategy would give us a high number of false negatives (words that identified as errors that are in fact words). Because my corpus is derived from a particular community with a particular set of concerns, it is possible to expand the wordlists to capture some of the specialized language of the community. I chose to store each specialized wordlist separately, and to pull all the lists together into a single list of unique values within the corpus processing steps. This enables me to use the lists modularly, and to isolate a particular subset if a problem arise.

## King James Bible

One of the most ubiquitous influences on the language of the SDA writers was the Bible, particularly in the King James translation. From scriptural quotations to references to individuals and use biblical of metaphors, the Bible saturated the consciousness of this nascent religious movement. To capture that language, and to reintroduce the relevant one and two letter words that I removed from the base SCOWL list, I (somewhat sacrilegiously) converted the text of the King James Bible from the [Christian Classics Ethereal Library](https://www.ccel.org/ccel/bible/kjv.txt) into a list of unique words. 

The code I used to create the wordlist from the text file is included in [module appendix](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/appendix/create-scriptural-word-list.ipynb). Here I am previewing the results of that transformation.


```python
kjv = readfile('data/', '2017-05-24-kjv-wordlist.txt').splitlines()
```


```python
len(kjv)
```




    14238




```python
kjv[:10]
```




    ['spider',
     'rocks',
     'biatas',
     'apparently',
     'strip',
     'anchor',
     'dinaites',
     'entangled',
     'adida',
     'salchah']




```python
word_lists = ['2017-05-05-base-scowl-list.txt','2017-05-24-kjv-wordlist.txt']
compiled_dict = create_spelling_dictionary('data', word_lists)
```


```python
get_doc_errors(input_dir, filename, compiled_dict)
```




    {'(',
     ']',
     'bined',
     'brans',
     'caseine',
     'centage',
     'com-',
     'con-',
     'connec-',
     'di-',
     'e',
     'eral',
     'ess',
     'gestive',
     'manu-',
     'min-',
     'nitroge-',
     'nutri-',
     'o)',
     'per-',
     'proc-',
     'sidered',
     'soja',
     'tion',
     'tious',
     'ñ'}



## Seventh-day Adventist People and Places

A second set of subject specific language comes from within the SDA. Using the Yearbooks produced by the denomination starting in 1883, I have compiled lists of the people serving leadership roles within the denomination, from Sabbath School teachers to the President of the General Conference. Browsing through the reported errors, many are people and place names. Since I had the data available from earlier work, I compiled the SDA last names and place names into wordlists.

The code for creating wordlists from my datafiles, which are in Google Docs, is documented in the [module appendix](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/appendix/create-SDA-people-and-places-lists.ipynb).

Note: There are duplicates in the list of people because I forgot to limit the list to the unique names before saving to a file. While unsightly, the only consequence of this is a little more computation work when I make the combined spelling dictionary.


```python
sda_people = readfile('data/', '2016-12-07-SDA-last-names.txt').splitlines()
```


```python
sda_people[:10]
```




    ['Butler',
     'Haskell',
     'Henry',
     'Kellogg',
     'Kellogg',
     'Oyen',
     'Sisley',
     'Fargo',
     'Hall',
     'Hall']




```python
sda_places = readfile('data/', '2016-12-07-SDA-place-names.txt').splitlines()
```


```python
sda_places[:10]
```




    ['Gray',
     'Oroville',
     'Shreveport',
     'Sāo',
     'Alto',
     'Central',
     'Castlereagh',
     'Warrenton',
     'Alexandria',
     'Cannelton']




```python
word_lists = ['2017-05-05-base-scowl-list.txt',
              '2017-05-24-kjv-wordlist.txt',
              '2016-12-07-SDA-last-names.txt',
              '2016-12-07-SDA-place-names.txt'
             ]
compiled_dict = create_spelling_dictionary('data', word_lists)
```


```python
get_doc_errors( input_dir, filename, compiled_dict)
```




    {'(',
     ']',
     'bined',
     'brans',
     'caseine',
     'centage',
     'com-',
     'con-',
     'connec-',
     'di-',
     'e',
     'eral',
     'ess',
     'gestive',
     'manu-',
     'min-',
     'nitroge-',
     'nutri-',
     'o)',
     'per-',
     'proc-',
     'sidered',
     'soja',
     'tion',
     'tious',
     'ñ'}



## USGS Locations and Roman Numerals

The final two external dataset I used to minimize false identification of errors were a list of U.S. city and town names from the [USGS](https://nationalmap.gov/small_scale/atlasftp.html?openChapters=chpref#chpref) and a list of roman numerals, as a number of these were removed from the base list when I filtered the words under 3 characters long. The code for converting the shape file from the USGS into a list of place names is included in the [module appendix](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/appendix/create-list-of-US-place-names.ipynb).


```python
us_places = readfile('data/', '2017-01-03-US-place-names.txt').splitlines()
```


```python
us_places[:10]
```




    ['attu',
     'point',
     'hope',
     'point',
     'lay',
     'diomede',
     'gambell',
     'tin',
     'city',
     'savoonga']




```python
word_lists = ['2017-05-05-base-scowl-list.txt',
              '2017-05-24-kjv-wordlist.txt',
              '2016-12-07-SDA-last-names.txt',
              '2016-12-07-SDA-place-names.txt',
              '2017-01-03-US-place-names.txt',
              '2017-02-14-roman-numerals.txt'
             ]
compiled_dict = create_spelling_dictionary('data', word_lists)
```


```python
get_doc_errors(input_dir, filename, compiled_dict)
```




    {'(',
     ']',
     'bined',
     'brans',
     'caseine',
     'centage',
     'com-',
     'con-',
     'connec-',
     'di-',
     'e',
     'eral',
     'ess',
     'gestive',
     'manu-',
     'min-',
     'nitroge-',
     'nutri-',
     'o)',
     'per-',
     'proc-',
     'sidered',
     'soja',
     'tion',
     'tious',
     'ñ'}



# Next Steps

With these lists in hand, I went through the different titles in the corpus and identified frequently used words that were escaping the above wordlists. As I will outline in the next notebook, many of the words that I found, which had not been captured by these wordlists, were related to religious persons and theological ideas; were alternative spellings created either intentionally or due to editor error; or can be attributed to John H. Kellogg and the health reform writings of the denomination.

# Final wordlists

The final wordlists are included in the data folder for this module. They are:

+ [Base SCOWL List](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/corpus-processing/data/2017-05-05-base-scowl-list.txt)
+ [KJV Words List](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/corpus-processing/data/2017-05-24-kjv-wordlist.txt)
+ [SDA Last Names](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/corpus-processing/data/2016-12-07-SDA-last-names.txt)
+ [SDA Place Names](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/corpus-processing/data/2016-12-07-SDA-place-names.txt)
+ [US Place Names](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/corpus-processing/data/2017-01-03-US-place-names.txt)
+ [Roman Numerals](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/module-2/corpus-processing/data/2017-02-14-roman-numerals.txt)

*You can run this code locally using the [Jupyter notebook available via Github](https://github.com/jerielizabeth/Gospel-of-Health-Notebooks/blob/master/blogPosts/Know%20Your%20Sources%20(Part%202).ipynb).*
---



