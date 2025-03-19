(how-to-import)=
# How to import data for use with QIIME 2

:::{warning}
Transfer of this document from `https://docs.qiime2.org` is in progress (as of 17 March 2025). 🪚

The goal of this document is to provide specific examples on how to carry out the most commonly used imports of data into QIIME 2 Artifacts.
It's challenging to compile this though, because I don't have good data on the frequency at which the different imports are used.[^import-statistics]
I'm therefore going to consider this document a work in progress, focusing on compiling the most relevant information in consultation with users and developers, and based on [the most viewed forum posts on importing](https://forum.qiime2.org/tag/import?ascending=false&order=views).

If you have questions about importing that aren't answered here, post to the forum.
If you think specific examples would be helpful for others, post an issue on the [amplicon-docs issue tracker](https://github.com/qiime2/amplicon-docs/issues).
Issues should include detailed information (e.g., including small example data that could be used under a CC-BY license, example working import commands, and/or helpful related discussions from the forum or elsewhere).
(If you don't have this detailed information, starting with a question on the forum is recommended over posting to the issue tracker.)
:::

:::{note}
This document currently presents importing using the command line interface only.
Transitioning of this content to usage examples, which will then present importing through other interfaces, is [pending](https://github.com/qiime2/amplicon-docs/issues/10).
:::

A QIIME 2 analysis almost always starts with importing data for use in QIIME 2, and this can also unfortunately be one of the most difficult steps of using QIIME 2 for users.
Importing creates a [QIIME 2 artifact](getting-started:artifacts-and-visualizations) from data in another format, such as a `.biom` file or one or more `.fastq` files.
You can learn about why this is needed and why it's hard in [](import-explanation).

The first step in determining how to import your data is figuring out what artifact class you're trying to import.
The following sections present importing of different artifact classes, ordered by how common we think they are to import in practice.
**You don't need to read all of the sections below but rather jump to the section that describes the data that you're trying to import.**
We also don't present all of the importable artifact classes here, as many of them are rarely used in importing (rather they represent intermediary data used by QIIME 2).
Using the command line interface, you can run `qiime tools list-types` to see a list of all importable artifact classes.

As always, we're here to help on [the forum](https://forum.qiime2.org) if you get stuck.
There are [lots of existing discussions about importing](https://forum.qiime2.org/tag/import?ascending=false&order=views) and if after searching you haven't found an answer to your question, post with a description of the data that you're trying to import and we'll help you figure out how to proceed.

(import-fastq-sequencing-data)=
## Importing "fastq sequencing data"

Most users begin their QIIME 2 analysis with "raw sequencing data" in the form of `.fastq.gz` files.

::::{margin}
:::{note}
This section refers to `.fastq.gz` files but it applies directly to `.fastq` files as well.
Files ending with `.gz` are compressed files, similar to `.zip` files.
`.fastq.gz` are more common for storing and moving fastq data because they're *much* more efficient than `.fastq` files, which can be very large and are highly compressible.
:::
::::

Raw microbiome data typically exists in one of two forms: multiplexed or demultiplexed.
In multiplexed data, sequences from all samples are grouped together in one or more files.
In demultiplexed data, sequences are separated into different files based on the sample they are derived from.
Data can be demultiplexed before it's delivered to you, or it can be delivered still multiplexed in which case you can use QIIME 2 to demultiplex the data.

:::{tip}
Generally speaking, it's more convenient to have your data delivered to you already demultiplexed because it means that you don't have to understand how it was multiplexed to demultiplex it.
:::

:::{tip} Differentiating demultiplexed and multiplexed sequencing data
:class: dropdown

The number of files that you are starting with is the key to determining whether your data are multiplexed or demultiplexed.
If you have one, two, three or four `.fastq.gz` files, it's almost certain that you have multiplexed data.
If the number of `.fastq.gz` files that you have is equal to your number of samples times one, two, three or four, it's almost certain that you have demultiplexed data.
If you're still unsure whether your data is multiplexed or demultiplexed, get in touch on the QIIME 2 Forum and include a list of your `.fastq.gz` filenames.
:::

:::{tip} Understanding Illumina `.fastq.gz` file names
:class: dropdown

Most Illumina sequencing runs are paired-end, meaning that sequence reads are generated in two directions: the "forward reads" begin at the 5' end of the amplicon, and the "reverse reads" begin at the 3' end of the amplicon.
These reads are stored in separate files, usually designated with an `_R1_` (for the forward reads) somewhere in the file name or `_R2_` (for the reverse reads) somewhere in the file name.
In some cases, there may also be one or two "index" or "barcode" read files, designated with `_I1_` in the filename (or `_I1_` and `_I2_` in the names of separate files).

The sequence data from all of your samples is contained in the `R1` files if you performed a single-end sequencing run, or in the `R1` and `R2` files if you performed a paired-end sequencing run.
If you have an `I1` file, that contains the sequence barcodes which during PCR were added to the sequences on a sample-specific basis.
If you also have an `I2` file, this means that a dual-barcoding scheme was used for associating sequences with samples.
In either case, the single barcode or the combination of forward and reverse barcodes define which sample a given sequence was isolated from.

If you have many `.fastq.gz` files, your data are likely demultiplexed.
In this case, you'll typically see either an `R1` or a pair of `R1` and `R2` files for each of your samples.
Often you'll be able to recognize your sample identifiers in the filenames, though there is typically a lot of additional information in there as well.
:::

### Demultiplexed sequence data

(import-fastq-manifest)=
#### "Fastq manifest" formats

We recommend importing demultiplexed data using a fastq manifest file.
This format is not specific to any sequencing instrument, but rather is generally used for importing demultiplexed fastq data.
This file should be easy for your sequencing center to generate for you, so you can ask them to provide it or you can generate one yourself.

::::{margin}
:::{tip}
[`fq-manifestor`](https://github.com/gregcaporaso/fq-manifestor) is a script that may help you generate fastq manifest files.
:::
::::

A fastq manifest file is a type of [sample metadata file](https://use.qiime2.org/en/latest/references/metadata.html) that maps sample identifiers to one or two absolute filepaths pointing at `.fastq.gz` (or `.fastq`) files, depending on whether you're importing data from a single- or paried-end run.

::::{margin}
:::{tip}
For convenience, the absolute filepaths may contain environment variables (e.g., `$HOME` or `$PWD`).
:::
::::

The following examples present fastq manifest files for single-end and paired-end read data.

:::::{tab-set}

::::{tab-item} Single-end reads
:sync: single-end-fq-manifest
:::
sample-id absolute-filepath
sample-1  /scratch/microbiome/sample1_R1.fastq.gz
sample-2  /scratch/microbiome/sample2_R1.fastq.gz
:::
::::

::::{tab-item} Paired-end reads
:sync: paired-end-fq-manifest
:::
sample-id forward-absolute-filepath   reverse-absolute-filepath
sample-1  /scratch/microbiome/sample1_R1.fastq.gz  /scratch/microbiome/sample1_R2.fastq.gz
sample-2  /scratch/microbiome/sample2_R1.fastq.gz  /scratch/microbiome/sample2_R2.fastq.gz
:::
::::
:::::

You're almost certainly interested in one of two variants of this format: one for single-end read data and one for pair-end read data.

::::{margin}
:::{warning}
If you're working with data generated roughly in 2020 or earlier, you may need to know the [PHRED offset](http://scikit-bio.org/docs/latest/generated/skbio.io.format.fastq.html#quality-score-variants) used in the quality scores.
As discussed in [](import-explanation), this is required to accurately interpret the quality scores in your fastq files, and this information is not present in the fastq files themselves - so the only way QIIME 2 can know is if you explicitly provide that information.
For most modern sequencing data, the PHRED offset is 33, but for some legacy data it may be 64.

The import commands in this section would be adapted to use 64 in place of 33 in the two format names - i.e., you'd pass `SingleEndFastqManifestPhred64V2` or `PairedEndFastqManifestPhred64V2` as the *input format*.
:::
::::


The following import commands should allow you to import your demultiplexed sequences, assuming you have a fastq manifest file named `fq-manifest.tsv`.

:::::{tab-set}

::::{tab-item} Single-end reads, PHRED 33
:sync: single-end-fq-manifest
:::
qiime tools import \
 --type 'SampleData[SequencesWithQuality]' \
 --input-path fq-manifest.tsv \
 --output-path demux.qza \
 --input-format SingleEndFastqManifestPhred33V2
:::
::::

::::{tab-item} Paired-end reads, PHRED 33
:sync: paired-end-fq-manifest
:::
qiime tools import \
 --type 'SampleData[PairedEndSequencesWithQuality]' \
 --input-path fq-manifest.tsv \
 --output-path demux.qza \
 --input-format PairedEndFastqManifestPhred33V2
:::
::::
:::::

(import-casava)=
#### Casava 1.8 paired-end demultiplexed fastq

The Casava 1.8 paired-end demultiplexed fastq format is a format for demultiplexed sequence data that is **very specific to the software used to create it**.
There are two `fastq.gz` files for each sample in the study, each containing the forward or reverse reads for that sample.
The file name includes the sample identifier.
The forward and reverse read file names for a single sample might look like `sample-1_15_L001_R1_001.fastq.gz` and `sample-1_15_L001_R2_001.fastq.gz`, respectively.
The underscore-separated fields in this file name are:

1.  the sample identifier,
2.  the barcode sequence or a barcode identifier,
3.  the lane number,
4.  the direction of the read (i.e. R1 or R2), and
5.  the set number.

If you're lucky enough to have data that is in this format exactly, you can import it as follows (assuming it's in a directory called `my-sequence-data`):

:::
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path my-sequence-data/ \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux.qza
:::

More often, if you have demultiplexed sequence data, you'll need to [import using a fastq manifest file](import-fastq-manifest).

## Importing "-omics feature tables"

`FeatureTable` is almost certainly the most frequent artifact class used with QIIME 2.
There are many actions that work on these, and most support arbitrary individual[^individual-omics] -omics data types.
If you generate a feature table outside of QIIME 2, you can import for use with the many QIIME 2 actions that work on these.

The main thing you need to know to import your feature table into QIIME 2 is the type of data it contains.
Counts of features (e.g., ASVs, genes, pathways, proteins, metabolites, ...) on a per sample basis are described with the subclass `Frequency`.
Relative frequencies (i.e., fractions such that the sum across all features in a sample is `1.0`) are described with the subclass `RelativeFrequency`.
There are others, but those are the most common.

::::{margin}
:::{warning}
It is critical that you correctly describe the type of data your feature table contains.
Don't assume or guess!
Making an incorrect choice will likely result in your performing analyses that are problematic or meaningless with your data type.
:::
::::

### Importing from .biom (v2.1.0, default)

Input:
- A feature table in `.biom` format, adhering to the [BIOM v2.1.0 format specification](http://biom-format.org/documentation/format_versions/biom-2.1.html) ([example](https://data.qiime2.org/2025.4/tutorials/importing/feature-table-v210.biom)).

This is currently the default, so a feature table containing frequencies (i.e., `FeatureTable[Frequency]`) could be imported as follows:

:::
qiime tools import \
  --input-path feature-table-v210.biom \
  --type 'FeatureTable[Frequency]' \
  --output-path feature-table.qza
:::

Alternatives:
- If your table contains relative frequencies, you would provide the artifact class `FeatureTable[RelativeFrequency]` as the `type`.


::::{tip} Importing taxonomy information from biom formats
:class: dropdown
:label: import-taxonomy-from-biom
Unlike the biom format, QIIME 2 maintains feature and sample metadata and annotations in separate files from the feature table.
This simplifies working with multiple different annotations (e.g., to compare taxonomic annotations using two different reference databases).
If you have taxonomy information in a biom table and want to use that with QIIME 2, you can import that into an artifact of class `FeatureData[Taxonomy]` as follows:

:::
qiime tools import \
  --input-path feature-table.biom \
  --output-path taxonomy.qza \
  --input-format BIOMV210Format \
  --type "FeatureData[Taxonomy]"
:::
::::

### Importing from .biom (v1.0.0)

Input:
- A feature table in `.biom` format, adhering to the [BIOM v1.0.0 format specification](http://biom-format.org/documentation/format_versions/biom-1.0.html) ([example](https://data.qiime2.org/2025.4/tutorials/importing/feature-table-v100.biom)).

:::
qiime tools import \
  --input-path feature-table-v100.biom \
  --type 'FeatureTable[Frequency]' \
  --output-path feature-table.qza \
  --input-format BIOMV100Format
:::

Alternatives:
- If your table contains relative frequencies, you would provide the artifact class `FeatureTable[RelativeFrequency]` as the `type`.

### Importing from other feature table formats

If you have a feature table in a format that is not one of the two listed above, [we're working on additional options for importing](https://github.com/qiime2/q2-types/issues/140).
In the meantime, see [forum posts on this topic](https://forum.qiime2.org/search?q=tag%3Afeature-table%20%23import%20order%3Alikes).

<!--
### Multiplexed sequence data

#### "EMP protocol" multiplexed paired-end fastq

##### Format description

Paired-end "[Earth Microbiome Project (EMP) protocol](http://www.earthmicrobiome.org/protocols-and-standards/)" formatted reads should have three `fastq.gz` files total:

1.  one `forward.fastq.gz` file that contains the forward sequence
    reads,
2.  one `reverse.fastq.gz` file that contains the reverse sequence
    reads,
3.  one `barcodes.fastq.gz` file that contains the associated barcode
    reads

In this format, sequence data is still multiplexed (i.e. you have only one forward and one reverse `fastq.gz` file containing raw data for all of your samples).

Because you are importing multiple files in a directory, the filenames `forward.fastq.gz`, `reverse.fastq.gz`, and `barcodes.fastq.gz` are *required*.
You may need to rename the files obtained from your sequencing center to use these file names.

If those three files are in a directory called `my-sequence-data`, your import command would look like the following:

:::
qiime tools import \
  --type EMPPairedEndSequences \
  --input-path my-sequence-data \
  --output-path emp-paired-end-sequences.qza
:::

### Sequences without quality information (i.e. FASTA)

QIIME 2 currently supports importing the QIIME 1 `seqs.fna` file\_
format, which consists of a single FASTA file with exactly two lines per
record: header and sequence. Each sequence must span exactly one line
and cannot be split across multiple lines. The ID in each header must
follow the format `<sample-id>_<seq-id>`. `<sample-id>` is the
identifier of the sample the sequence belongs to, and `<seq-id>` is an
identifier for the sequence *within* its sample.

An example of importing and dereplicating this kind of data can be found
in the `OTU Clustering tutorial <otu-clustering>`{.interpreted-text
role="doc"}.

Other FASTA formats like FASTA files with differently formatted sequence
headers or per-sample demultiplexed FASTA files (i.e. one FASTA file per
sample) are not currently supported.

### Per-feature unaligned sequence data (i.e., representative FASTA sequences)

#### Format description

Unaligned sequence data is imported from a FASTA formatted file
containing DNA sequences that are not aligned (i.e., do not contain
[-]{.title-ref} or [.]{.title-ref} characters). The sequences may
contain degenerate nucleotide characters, such as `N`, but some QIIME 2
actions may not support these characters. See the [scikit-bio FASTA
format
description](http://scikit-bio.org/docs/latest/generated/skbio.io.format.fasta.html#fasta-format)
for more information about the FASTA format.

##### Obtaining example data

::: {.download url="https://data.qiime2.org/2025.4/tutorials/importing/sequences.fna" saveas="sequences.fna"}
:::

#### Importing data

::: command-block
qiime tools import \--input-path sequences.fna \--output-path
sequences.qza \--type \'FeatureData\[Sequence\]\'
:::

### Per-feature aligned sequence data (i.e., aligned representative FASTA sequences)

#### Format description

Aligned sequence data is imported from a FASTA formatted file containing
DNA sequences that are aligned to one another. All aligned sequences
must be exactly the same length. The sequences may contain degenerate
nucleotide characters, such as `N`, but some QIIME 2 actions may not
support these characters. See the [scikit-bio FASTA format
description](http://scikit-bio.org/docs/latest/generated/skbio.io.format.fasta.html#fasta-format)
for more information about the FASTA format.

##### Obtaining example data

::: {.download url="https://data.qiime2.org/2025.4/tutorials/importing/aligned-sequences.fna" saveas="aligned-sequences.fna"}
:::

#### Importing data

::: command-block
qiime tools import \--input-path aligned-sequences.fna \--output-path
aligned-sequences.qza \--type \'FeatureData\[AlignedSequence\]\'
:::

### Feature table data {#importing feature tables}

You can also import pre-processed feature tables into QIIME 2.

#### BIOM v1.0.0

##### Format description

See the [BIOM v1.0.0 format
specification](http://biom-format.org/documentation/format_versions/biom-1.0.html)
for details.

###### Obtaining example data

::: {.download url="https://data.qiime2.org/2025.4/tutorials/importing/feature-table-v100.biom" saveas="feature-table-v100.biom"}
:::

##### Importing data

::: command-block
qiime tools import \--input-path feature-table-v100.biom \--type
\'FeatureTable\[Frequency\]\' \--input-format BIOMV100Format
\--output-path feature-table-1.qza
:::

#### BIOM v2.1.0

##### Format description

See the [BIOM v2.1.0 format
specification](http://biom-format.org/documentation/format_versions/biom-2.1.html)
for details.

###### Obtaining example data

::: {.download url="https://data.qiime2.org/2025.4/tutorials/importing/feature-table-v210.biom" saveas="feature-table-v210.biom"}
:::

##### Importing data

::: command-block
qiime tools import \--input-path feature-table-v210.biom \--type
\'FeatureTable\[Frequency\]\' \--input-format BIOMV210Format
\--output-path feature-table-2.qza
:::

### Phylogenetic trees

#### Format description

Phylogenetic trees are imported from newick formatted files. See the
[scikit-bio newick format
description](http://scikit-bio.org/docs/latest/generated/skbio.io.format.newick.html)
for more information about the newick format.

##### Obtaining example data

::: {.download url="https://data.qiime2.org/2025.4/tutorials/importing/unrooted-tree.tre" saveas="unrooted-tree.tre"}
:::

#### Importing data

::: command-block
qiime tools import \--input-path unrooted-tree.tre \--output-path
unrooted-tree.qza \--type \'Phylogeny\[Unrooted\]\'
:::

If you have a rooted tree, you can use `--type 'Phylogeny[Rooted]'`
instead.
-->

## Importing metadata (tl;dr: metadata doesn't get imported)

Sample metadata and feature metadata don't need to be imported, but rather can be loaded and used directly from `.tsv` files.
To learn more about metadata in QIIME 2, refer to refer to [*Using QIIME 2*'s Metadata file format](https://use.qiime2.org/en/latest/references/metadata.html).

[^import-statistics]: It would be possible for us to compile this information because imports are recorded in data provenance, and we could assess that across the user community when provenance is parsed by [QIIME 2 View](https://view.qiime2.org).
 To date though, we've never collected usage information (or any other data) through QIIME 2 View.

[^individual-omics]: If your feature table integrates different -omics data types, specialized methods may be required.
 Best to reach out on the forum for input here.
