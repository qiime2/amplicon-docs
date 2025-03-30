(experienced-researchers)=
# QIIME 2 for experienced microbiome researchers

This document is intended for experienced microbiome researchers who already know how to process microbiome marker gene data and need to know the QIIME 2 commands pertaining to specific steps.

:::{tip}
We recommend reading [](getting-started) before this document, as it provides some background information on QIIME 2 itself that is helpful for learning the platform quickly.
[](conceptual-overview) contains a more theoretical overview of microbiome data processing, and can be read either before or after this document.
:::

:::{note}
General updates are planned for this document (see [](https://github.com/qiime2/amplicon-docs/issues/3)).
:::

## Why use QIIME 2?

Transitioning to QIIME 2 can be difficult for users who are used to processing data with their own tools and scripts, and who want fine control over every step in the process.
We understand the frustrating learning curve for experienced microbiome researchers, but believe that the community, open-sourced nature, and commitment to reproducible science make switching to QIIME 2 worth any initial frustrations.

By providing a common framework for microbiome data analysis, QIIME 2 brings together a **vibrant and inclusive community**.
The QIIME 2 community includes both established leaders in microbiome research as well as newcomers: all are encouraged to participate and learn from each other.
By joining the QIIME 2 community as an established microbiome researcher, you will automatically be connected to other leaders in this field and can more easily work together to propel the development and implementation of best practices in microbiome research for broad use.
By joining as a newcomer, you can meet and learn from others with common interests and backgrounds.
The [QIIME 2 Forum](https://forum.qiime2.org/) is the hub of the QIIME 2 community, and contains a wealth of information on how to perform microbiome data processing and analysis, as well as fruitful discussion on best practices in this space.

Furthermore, by wrapping tools into a common framework, **data processing pipelines are streamlined**.
With QIIME 2, most data processing workflows can be consolidated into one (or a few) bash scripts, reducing the number of different programs or executables you need to call and the number of re-formatting data steps that are necessary.

Finally, QIIME 2 is **open-source, free for all use (including commercial), and specifically designed for experienced researchers to contribute and expand the reach of their work.**
Any tool can be integrated with QIIME 2 through a plugin, the development of which is documented in [*Developing with QIIME 2*](https://develop.qiime2.org), a free online book.
Writing a QIIME 2 plugin for your methods is a great way to get your methods in the hands of thousands of users around the world, and there are many benefits to building plugins.

### Pro-tips for power users

That said, here are a couple of tips that should improve your experience in transitioning your workflows to QIIME 2:

**Pro-tip #1: QIIME 2 artifacts are just zip files**.
They contain your data, as well as some QIIME 2 generated metadata.
Learn more about these in [](archives).

**Pro-tip #2: The QIIME 2 command line interface tools can be slow because they unzip input data each time you call them.**
If you need to process your data more interactively, you might want to use the Python 3 API, and/or an [Artifact Cache](https://use.qiime2.org/en/latest/tutorials/use-the-artifact-cache.html).
These can make your analysis workflows much quicker.

## Data processing steps

The processing steps we'll cover in this discussion include:

- Preparing your sample metadata
- Importing raw sequence (FASTQ) data into QIIME 2.
- Demultiplexing data (i.e. mapping each sequence to the sample it came from).
- Removing non-biological parts of the sequences (e.g., adapters and primers).
- Performing quality control and:
  - denoising sequences with DADA2 or deblur, and/or
  - quality filtering, length trimming, and clustering with VSEARCH or dbOTU
- Assigning taxonomy
- Generating phylogenetic trees
- Analyzing data and gaining insight into your microbiomes!

[](conceptual-overview) and [](available-plugins) can give you ideas for additional possible processing and analysis steps.

### Preparing your metadata

QIIME 2 has little in the way of opinions in terms of how your metadata must be formatted.
Briefly, the data should be in a tab-separated text file (`.tsv`), where the first row contains metadata column headers, and the first column contains sample ids.
Sample ids must be unique, and the column header for the first column should be `sample-id` or `id` (there are a few other options as well).

The metadata file format is defined in *Using QIIME 2* [here](https://use.qiime2.org/en/latest/references/metadata.html).
You can find an example in the *Moving Pictures tutorial* [here](xref:q2doc-gut-to-soil-target#sample-metadata).

### Importing data into QIIME 2: `qiime tools import`

If you're using QIIME 2 to process your data, the first thing you need to do is get that data into a format that QIIME 2 can understand.
The need for importing is explained in [](import-explanation), and examples illustrating the most common import needs of users are presented in [](how-to-import).

This step has the potential to be the most confusing part of the QIIME 2 pipeline as there are dozens of import and format types to choose from.
To see a full list of available import/format types use:
- `qiime tools list-types`
- `qiime tools list-formats`

If you're importing FASTQ data that you've generated, the most straight-forward approach is using a [manifest file](import-fastq-manifest): a text file that maps your sample identifiers to file paths to their forward and reverse (if applicable) read FASTQ files.
If you have sequencing data with one of two very specific formats, you may alternatively be able to use [other import formats](importing-fastq), but importing with a manifest file will always work.

If you want to import FASTA files or a feature table directly, you can also do that by using a different `--type` flag for `qiime tools import`.
[](how-to-import) provides examples for these imports.

### Demultiplexing sequences

Relevant plugins:
- [`q2-demux`](q2-plugin-demux)
- [`q2-cutadapt`](q2-plugin-cutadapt)

If you have reads from multiple samples in the same file, you'll need to demultiplex your sequences.

If your barcodes have already been removed from the reads and are in a separate file, you can use [`emp-paired`](q2-action-demux-emp-paired) to demultiplex these.

If your barcodes are still in your sequences, you can use functions from the `q2-cutadapt`.
The [`demux-single`](q2-action-cutadapt-demux-single) method looks for barcode sequences at the beginning of your reads (5' end) with a certain error tolerance, removes them, and returns sequence data separated by each sample.
The QIIME 2 Forum has a [post on the various functions available in cutadapt](https://forum.qiime2.org/t/demultiplexing-and-trimming-adapters-from-reads-with-q2-cutadapt/2313), including demultiplexing.
You can learn more about how `cutadapt` works under the hood by reading their [documentation](https://cutadapt.readthedocs.io/en/stable/index.html).

Note: Currently `q2-demux` and `q2-cutadapt` do not support demultiplexing dual-barcoded paired-end sequences, but only can demultiplex with barcodes in the forward reads.
For the time being, this type of demultiplexing needs to be done outside of QIIME 2 using other tools, for example [bcl2fastq](https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html).

(experienced-researchers:merging)=
### Merging paired end reads

Relevant plugins:
- [`q2-vsearch`](q2-plugin-vsearch)
- [`q2-dada2`](q2-plugin-dada2)

Whether or not you need to merge reads depends on how you plan to cluster or denoise your sequences into amplicon sequence variants (ASVs) or operational taxonomic units (OTUs).
If you plan to use DADA2 to denoise your sequences, do not merge --- [`denoise-paired`](q2-action-dada2-denoise-paired) performs read merging automatically after denoising each sequence.
If you plan to use deblur or OTU clustering methods next, join your sequences now.

If you need to merge your reads, you can use the [`merge-pairs`](q2-action-vsearch-merge-pairs) method.

(experienced-researchers:removing-nonbio-sequences)=
### Removing non-biological sequences

Relevant plugins:
- [`q2-cutadapt`](q2-plugin-cutadapt)
- [`q2-dada2`](q2-plugin-dada2)

If your data contains any non-biological sequences (e.g. primers, sequencing adapters, PCR spacers, etc), you should remove these.

The [`q2-cutadapt`](q2-plugin-cutadapt) plugin has comprehensive methods for removing non-biological
sequences from [paired-end](q2-action-cutadapt-trim-paired) or [single-end](q2-action-cutadapt-trim-single) data.

If you're going to use DADA2 to denoise your sequences, you can remove biological sequences at the same time as you call the denoising function.
All of DADA2's `denoise` actions have some sort of `--p-trim` parameter you can specify to remove base pairs from the 5' end of your reads.

### Grouping similar sequences

There are two main approaches for grouping similar sequences together: denoising and clustering.
[*Some theory: denoising and clustering*](conceptual-overview:denoising-and-clustering) provides more in-depth discussion of these approaches.

Regardless of how you group your sequences, the grouping methods will output:

1.  A feature table that tabulates counts of each feature (e.g., an amplicon sequence variant) on a per-sample basis (QIIME 2 Artifact Class: `FeatureTable[Frequency]`), and
1.  A table providing a representative sequence for each feature (QIIME 2 Artifact Class: `FeatureData[Sequence]`).

DADA2 and deblur will also produce a stats summary file with useful information regarding the filtering and denoising.

(experienced-researchers:denoising)=
### Denoising

Relevant plugins:
- [`q2-dada2`](q2-plugin-dada2)
- [`q2-deblur`](q2-plugin-deblur)

DADA2 and deblur are currently the two denoising methods available in QIIME 2 and both group sequences into amplicon sequence variants (ASV).

#### Preparing data for denoising

Both DADA2 and deblur perform quality filtering, denoising, and chimera removal, so you shouldn't need to perform any quality screening prior to running them.
That said, the deblur developers recommend doing an initial quality screen - this is illustrated in the *Moving Pictures tutorial's* [Deblur section](xref:q2doc-moving-pictures-target#deblur).
No quality filtering step is required before running DADA2.

Both methods have an option to truncate your reads to a constant length (which occurs prior to denoising).
In DADA2, this is the `--p-trunc-len` parameter; in deblur it's the `--p-trim-length` parameter.
The truncating parameter is optional for both DADA2 and deblur (though if you're using deblur you'll need to specify `--p-trim-length -1` to disable truncation).
Reads shorter than the truncation length are discarded and reads longer are truncated at that position.

#### Denoising with DADA2

The [`q2-dada2`](q2-plugin-dada2) has multiple methods to denoise reads:

- [`denoise-paired`](q2-action-dada2-denoise-paired) requires unmerged, paired-end Illumina reads (i.e. both forward and reverse).
- [`denoise-single-end`](q2-action-dada2-denoise-single) accepts either single-end or unmerged, paired-end Illumina reads.
 If you give it unmerged paired-end data, it will only use the forward reads (and do nothing with the reverse reads).
- [`denoise-pyro`](q2-action-dada2-denoise-pyro) accepts ion torrent or 454 data.
- [`denoise-css`](q2-action-dada2-denoise-pyro) accepts Pacbio CCS.

Note that DADA2 may be slow on very large datasets.
You can increase the number of threads to use with the `--p-n-threads` parameter.

#### Denoising with deblur

The [`q2-deblur`](q2-plugin-deblur) plugin has two methods to denoise sequences:

- [`denoise-16S`](q2-action-deblur-denoise-16S) denoises 16S rRNA data.
- [`denoise-other`](q2-action-deblur-denoise-other) denoises other types of sequences.

If you use `denoise-16S`, deblur performs an initial positive filtering step where it discards any reads which do not have minimum 60% identity similarity to sequences from the 85% OTU GreenGenes 13_8 database.
If you don't want to do this step, use the `denoise-other` method.

deblur can currently only denoise single-end reads.
It will accept unmerged paired-end reads as input, it just won't do anything with the reverse reads.
Note that deblur *can* take in *merged* reads and treat them as single-end reads, so you might want to merge your reads first if you're denoising with deblur.

### OTU Clustering

Relevant plugins:
- [`q2-vsearch`](q2-plugin-vsearch)

QIIME 2 can also perform OTU clustering using the [`q2-vsearch`](q2-plugin-vsearch) plugin.
This can include simple dereplication of sequences using [`dereplicate-sequences`](q2-method-vsearch-dereplicate-sequences), or [*de novo*](q2-method-vsearch-cluster-features-de-novo), [closed-reference](q2-method-vsearch-cluster-features-closed-reference), or [open-reference](q2-method-vsearch-cluster-features-open-reference) OTU clustering.

Before dereplicating or clustering your sequences, you should ensure that:

-   paired-end reads are merged (see [](experienced-researchers:merging))
-   non-biological sequences are removed (see [](experienced-researchers:removing-nonbio-sequences))
-   reads have undergone quality control, either [by denoising](experienced-researchers:denoising) or using [`q2-quality-filter`](q2-plugin-quality-filter)
-   if you want to strictly dereplicate your sequences, all reads should be trimmed to the same length using [`q2-cutadapt`](q2-plugin-cutadapt)

For additional information, see [](cluster-reads-into-otus).

### Taxonomic annotation

Relevant plugins:
- [`q2-feature-classifier`](q2-plugin-feature-classifier) (also see [Bokulich et al. (2018)](https://doi.org/10.1186/s40168-018-0470-z))
- [`rescript`](q2-plugin-rescript) (also see [Robeson et al. (2019)](https://doi.org/10.1371/journal.pcbi.1009581))

There are two main approaches for assigning taxonomy, each with multiple methods available.

The first approach involves aligning reads to reference databases directly:
- [BLAST+ local alignment](q2-method-feature-classifier-classify-consensus-blast)
- [VSEARCH global alignment](q2-method-feature-classifier-classify-consensus-vsearch)
- [BLAST+ local alignment](q2-method-feature-classifier-classify-blast)
- [VSEARCH global alignment](q2-method-feature-classifier-classify-vsearch-global)

The second approach uses a machine learning classifier to assign likely taxonomies to reads, and can be used through [`classify-sklearn`](q2-method-feature-classifier-classify-sklearn).
This method needs a pre-trained model to classify the sequences.
You can either download one of the pre-trained taxonomy classifiers from our [data resources page](https://resources.qiime2.org), or train one yourself as described in [](train-feature-classifier).
[`rescript`](q2-plugin-rescript) provides many utilities that can help you access and prepare data for use in building your own taxonomic reference databases and classifiers.

## Generating phylogenetic trees

Relevant plugins:
- [`q2-phylogeny`](q2-plugin-phylogeny)
- [`q2-fragment-insertion`](q2-plugin-fragment-insertion)

QIIME 2 allows you to generate phylogenetic trees *de novo* with a few different underlying tools using the [`q2-phylogeny`](q2-plugin-phylogeny) plugin.
You can also generate phylogenetic trees by inserting short sequence reads into a reference phylogenetic tree using [`q2-fragment-insertion`](q2-plugin-fragment-insertion).

*De novo* trees are useful if you don't have a good reference.
These are often fairly low-quality trees however.

Reference-based phylogenetic reconstruction is useful when you have an existing reference tree.
These are generally higher quality than de novo trees.

In both cases, we consider the trees to be rough estimates of the evolutionary relationships between features that are useful in the computation of phylogenetic diversity metrics.



## Analyzing data and gaining insight into your microbiomes!

Relevant plugins:
- [Many in the amplicon distribution](available-plugins)
- [Many more on the QIIME 2 Library](https://library.qiime2.org)

At this point, you should be ready to analyze your feature table to answer your scientific questions.
QIIME 2 offers multiple built-in functions to analyze your data.
If you don't find what you're looking for, you can also [export your data](how-to-export) for analysis with other tools.
The [](moving-pictures-tutorial) has good examples of the types of visualizations and statistics that you can apply to your data.

Some of those include:
- [generating taxonomic composition barplots](q2-action-taxa-barplot),
- [generating interactive ordination (Emperor) plots](q2-action-emperor-plot),
- [calculating common diversity metrics](q2-action-diversity-core-metrics),
- [calculating phylogenetic diversity metrics](q2-action-diversity-core-metrics-phylogenetic),
- calculating uncommon diversity metrics: approximately [30 alpha diversity metrics](q2-action-diversity-alpha) and [20 beta diversity metrics](q2-action-diversity-beta),
- [computing](q2-action-composition-ancombc) and [visualizing](q2-action-composition-da-barplot) differential abundance across sample categories,
- [performing longitudinal data analysis](q2-plugin-longitudinal),
- developing machine learning tools to predict [categorical](q2-action-sample-classifier-classify-samples) or [continuous](q2-action-sample-classifier-regress-samples) metadata as a function of microbiome composition,

- and lots more.

## A library of plugins

The amplicon distribution is intended as a base of stable analytic functionality for microbiome marker gene analysis, but there are many other plugins that you can install in your amplicon distribution deployment that expand its functionality.
These plugins can generally be found on the [QIIME 2 Library](https://library.qiime2.org) and/or the [Community Contributions](https://forum.qiime2.org/c/community-contributions/15) category on the QIIME 2 Forum.
Some cool new plugins (as of 28 February 2025) include:

- [`q2-kmerizer`](https://github.com/bokulich-lab/q2-kmerizer): Enables diversity calculations that approximate those of phylogenetic methods without the use of a phylogenetic tree ([](https://doi.org/10.1128/msystems.01550-24)).
 This is useful when building a tree is too computationally expensive, or you're not confident that you have one that's reliable.
 Pretty neat!
- [`q2-micom`](https://library.qiime2.org/plugin/micom-dev/q2-micom): Enables inference of metabolic interactions in gut microbiome data using MICOM ([](https://doi.org/10.1128/mSystems.00606-19)).
- [`q2-boots`](https://library.qiime2.org/plugin/caporaso-lab/q2-boots): Supports bootstrapped and rarefaction-based diversity calculations with an interface that mirrors those in [`q2-diversity`](q2-plugin-diversity) ([](https://doi.org/10.12688/f1000research.156295.1)).
 This produces averaged alpha and beta diversity results across a user-defined number of bootstrapping or rarefaction iterations, such that these results can be used anywhere that individual alpha and beta diversity results can be used.
 Don't like the idea of throwing away data to support even sampling?
 `q2-boots` allows you to make diversity estimates based on all of your data.

Have fun! 😎