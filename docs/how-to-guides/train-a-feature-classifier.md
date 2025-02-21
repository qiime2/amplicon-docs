(train-feature-classifier)=
# How to train your own feature classifier

:::{warning}
Transfer of this document from `https://docs.qiime2.org` is in progress (as of 20 Feb 2025).
Expect some problematic formatting.
🪚
:::

This tutorial will demonstrate how to train `q2-feature-classifier` for
a particular dataset. We will train the [Naive
Bayes](http://scikit-learn.org/stable/modules/naive_bayes.html#multinomial-naive-bayes)
classifier using
[Greengenes](http://qiime.org/home_static/dataFiles.html) reference
sequences and classify the representative sequences from the [Moving
Pictures](../moving-pictures/index.html) dataset.

Note that several pre-trained classifiers are provided in the QIIME 2
`data resources <../data-resources>`{.interpreted-text role="doc"}.
These can be used for some common marker-gene targets (e.g., 16S rRNA
genes). Pre-trained classifiers for other marker genes are also
available on the [QIIME 2
forum](https://forum.qiime2.org/c/community-contributions/data-resources).

We will download and create several files, so first create a working
directory.

::: {.command-block no-exec=""}
mkdir training-feature-classifiers cd training-feature-classifiers
:::

## Obtaining and importing reference data sets

Two elements are required for training the classifier: the reference
sequences and the corresponding taxonomic classifications. To reduce
computation time for this tutorial we will use the relatively small
[Greengenes](http://qiime.org/home_static/dataFiles.html) 13_8 85% OTU
data set. **Do not use the 85% OTU data set used in this tutorial for
classification of real experimental data**. We recommend using more
information-rich sequences, e.g., reference sequences clustered at 99%
sequence similarity, for classification of real data. See the QIIME 2
`data resources page <../data-resources>`{.interpreted-text role="doc"}
for links to complete QIIME-compatible reference datasets.

:::: note
::: title
Note
:::

All sequence IDs present in the reference sequences must also be present
in the reference taxonomy. If using reference sequence databases that
have been clustered into OTUs, make sure that the corresponding
reference taxonomy is used. For example, if using the Greengenes 99% OTU
sequences, the 99% OTU taxonomy must also be used.
::::

We will also download the representative sequences from the [Moving
Pictures](../moving-pictures/index.html) tutorial to test our
classifier.

::: {.download url="https://data.qiime2.org/2025.4/tutorials/training-feature-classifiers/85_otus.fasta" saveas="85_otus.fasta"}
:::

::: {.download url="https://data.qiime2.org/2025.4/tutorials/training-feature-classifiers/85_otu_taxonomy.txt" saveas="85_otu_taxonomy.txt"}
:::

Next we import these data into QIIME 2 Artifacts. Since the Greengenes
reference taxonomy file (`85_otu_taxonomy.txt`{.interpreted-text
role="file"}) is a tab-separated (TSV) file without a header, we must
specify `HeaderlessTSVTaxonomyFormat` as the *source format* since the
default *source format* requires a header.

::: command-block
qiime tools import \--type \'FeatureData\[Sequence\]\' \--input-path
85_otus.fasta \--output-path 85_otus.qza

qiime tools import \--type \'FeatureData\[Taxonomy\]\' \--input-format
HeaderlessTSVTaxonomyFormat \--input-path 85_otu_taxonomy.txt
\--output-path ref-taxonomy.qza
:::

## Extract reference reads

It has been shown that taxonomic classification accuracy of 16S rRNA
gene sequences improves when a Naive Bayes classifier is trained on only
the region of the target sequences that was sequenced [(Werner et al.,
2012)](https://www.ncbi.nlm.nih.gov/pubmed/21716311). This may not
necessarily generalize to other marker genes (see note on fungal ITS
classification below). We know from the [Moving
Pictures](../moving-pictures/index.html) tutorial that the sequence
reads that we\'re trying to classify are 120-base single-end reads that
were amplified with the 515F/806R primer pair for 16S rRNA gene
sequences. We optimize for that here by extracting reads from the
reference database based on matches to this primer pair, and then
slicing the result to 120 bases.

::: command-block
qiime feature-classifier extract-reads \--i-sequences 85_otus.qza
\--p-f-primer GTGCCAGCMGCCGCGGTAA \--p-r-primer GGACTACHVGGGTWTCTAAT
\--p-trunc-len 120 \--p-min-length 100 \--p-max-length 400 \--o-reads
ref-seqs.qza
:::

:::: note
::: title
Note
:::

The `--p-trunc-len` parameter should only be used to trim reference
sequences if query sequences are trimmed to this same length or shorter.
Paired-end sequences that successfully join will typically be variable
in length. Single-end reads that are not truncated at a specific length
may also be variable in length. For classification of paired-end reads
and untrimmed single-end reads, we recommend training a classifier on
sequences that have been extracted at the appropriate primer sites, but
are not trimmed.
::::

:::: note
::: title
Note
:::

The primer sequences used for extracting reads should be the actual
DNA-binding (i.e., biological) sequence contained within a primer
construct. It should NOT contain any non-biological, non-binding
sequence, e.g., adapter, linker, or barcode sequences. If you are not
sure what section of your primer sequences are actual DNA-binding, you
should consult whoever constructed your sequencing library, your
sequencing center, or the original source literature on these primers.
If your primer sequences are \> 30 nt long, they most likely contain
some non-biological sequence.
::::

:::: note
::: title
Note
:::

The example command above uses the `min-length` and `max-length`
parameters to exclude simulated amplicons that are far outside of the
anticipated length distribution using those primers. Such amplicons are
likely non-target hits and should be excluded. If you adapt this command
for your own use, be sure to select settings that are appropriate for
the marker gene, not the settings used here. The `min-length` parameter
is applied \_[after]() the `trim-left` and `trunc-len` parameters, and
`max-length` \_[before](), so be sure to set appropriate settings to
prevent valid sequences from being filtered out.
::::

## Train the classifier

We can now train a [Naive
Bayes](http://scikit-learn.org/stable/modules/naive_bayes.html#multinomial-naive-bayes)
classifier as follows, using the reference reads and taxonomy that we
just created.

::: command-block
qiime feature-classifier fit-classifier-naive-bayes \--i-reference-reads
ref-seqs.qza \--i-reference-taxonomy ref-taxonomy.qza \--o-classifier
classifier.qza
:::

## Test the classifier

Finally, we verify that the classifier works by classifying the
representative sequences from the [Moving
Pictures](../moving-pictures/index.html) tutorial and visualizing the
resulting taxonomic assignments.

::: {.download url="https://data.qiime2.org/2025.4/tutorials/training-feature-classifiers/rep-seqs.qza" saveas="rep-seqs.qza"}
:::

::: command-block
qiime feature-classifier classify-sklearn \--i-classifier classifier.qza
\--i-reads rep-seqs.qza \--o-classification taxonomy.qza

qiime metadata tabulate \--m-input-file taxonomy.qza \--o-visualization
taxonomy.qzv
:::

## Classification of fungal ITS sequences

In our experience, fungal ITS classifiers trained on the [UNITE
reference database](https://unite.ut.ee/repository.php) do NOT benefit
from extracting/trimming reads to primer sites. We recommend training
UNITE classifiers on the full reference sequences. Furthermore, we
recommend the \"developer\" sequences (located within the
QIIME-compatible release download) because the standard versions of the
sequences have already been trimmed to the ITS region (excluding
portions of flanking rRNA genes that may be present in amplicons
generated with standard ITS primers).
