(conceptual-overview)=
# Conceptual overview of marker gene (i.e., amplicon) data analysis

:::{note}
This document was partially updated when transferred from `https://docs.qiime2.org`, but [some improvements can still be made](https://github.com/qiime2/amplicon-docs/issues/7).
:::

This is a guide for novice QIIME 2 users, and particularly for those who are new to microbiome research.
For experienced users who are already well versed in microbiome analysis (and those who are averse to uncontrolled use of emoji) mosey on over to [](expierienced-researchers).

:::{note}
If you haven't already read [](getting-started), we recommend starting there.
Some technical terminology related to the QIIME 2 Framework (Q2F) used in this document is introduced there.
:::

Welcome all newcomers! 👋
This guide will give you a conceptual overview of many of the [plugins and actions](getting-started:plugins) available in QIIME 2, and guide you to relevant documentation for deeper exploration.
As an *Explanation* article, this document doesn't provide specific commands to run, but rather discusses at a higher level what your analysis workflow might entail.
If you want specific commands that you can run and then adapt for your own work, our *Tutorial* articles are more aligned with what you're looking for.
We generally recommend starting with the [](moving-pictures-tutorial).

Consider this document to be your treasure map: QIIME 2 actions are the stepping stones on your path, and the flowcharts below will tell you where all the goodies are buried.
🗺️

Remember, *many paths lead from the foot of the mountain, but at the peak we all gaze at the same moon.* 🌕

## Let's get oriented

### Flowcharts

Before we begin talking about specific plugins and actions, we will discuss a conceptual overview of a typical workflow for analyzing marker gene sequence data.
And before we look at that overview, we must look at the key to our treasure map:

```{figure} ../_static/overview-flowchart-key.png
:label: flowchart-key
:alt: Key of symbols used in flowcharts.

Each type of {term}`Result` (i.e., [Artifacts and Visualizations](getting-started:artifacts-and-visualizations)) and {term}`Action` (i.e., {term}`methods <method>`, {term}`visualizers <visualizer>`, and {term}`pipelines <pipeline>`) is represented by a different color-coded node.
The edges connecting each node are either solid (representing either required input or output) or dashed (representing optional input).
```

In the flowcharts below:

- Actions are labeled with the name of the plugin and the name of the action.
  To learn more about how to use a specific plugin and action, you can look it up in [](available-plugins).
- Artifacts are labeled by their [artifact class](getting-started:artifact-classes).
- Visualizations are variously labeled as "visualization," some name that represents the information shown in that visualization, or replaced with an image representing some of the tasty information you might find inside that visualization...
 🍙

### Useful points for beginners

Just a few more **important points** before we go further:

1. The guide below is not exhaustive by any means.
   It only covers some of the chief actions in the QIIME 2 amplicon distribution.
   There are many more actions and plugins to discover.
   Curious to learn more?
   Refer to [](available-plugins), or if you're working on the command line, call `qiime --help`.
1. The flowcharts below are designed to be as simple as possible, and hence omit many of the inputs (particularly optional inputs and metadata) and outputs (particularly statistical summaries and other minor outputs) and all of the possible parameters from most actions.
   Many additional actions (e.g., for displaying statistical summaries or fiddling with feature tables 🎻) are also omitted.
   Now that you know all about the help documentation ([](available-plugins)), use it to learn more about individual actions, and other actions present in a plugin (hint: if a plugin has additional actions not described here, they are probably used to examine the output of other actions in that plugin).
1. Metadata is a central concept in QIIME 2.
   We do not extensively discuss metadata in this guide.
   Instead, find discussion of metadata in []().
1. There is no one way to do things in QIIME 2.
   Nor is there a "QIIME 2" approach.
   *Many paths lead from the foot of the mountain...* ⛰️
   Many of the plugins and actions in QIIME 2 wrap independent software or pre-existing methods.
   The QIIME 2 Framework (Q2F), discussed in [*Using QIIME 2*](https://use.qiime2.org), is the glue that makes the magic happen.
1. Do not forget to cite appropriately!
   Unsure what to cite?
   To see the a plugin or method's relevant citations, refer its help text.
   Or, better yet, view an artifact or visualization using [QIIME 2 View](https://view.qiime2.org).
   The "citations" tab will contain information on **all** relevant citations used for the generation of that file.
   Groovy.
   😎

💃💃💃

## Conceptual overview

Now let us examine a conceptual overview of the various possible workflows for examining marker gene sequence data {ref}`overview-marker-gene`.
QIIME 2 allows you to enter or exit anywhere you'd like, so you can use QIIME 2 for any or all of these steps.

```{figure} ../_static/overview-marker-gene.png
:label: overview-marker-gene
:alt: Flowchart providing an overview of a typical QIIME 2-based microbiome marker gene analysis workflow.

Flowchart providing an overview of a typical QIIME 2-based microbiome marker gene analysis workflow.
The edges and nodes in this overview do not represent specific actions or data types, but instead represent conceptual categories, e.g., the basic types of data or analytical goals we might have in an experiment.
Discussion of these steps and terms follows.
```

All data must be [imported](import-explanation) into a QIIME 2 artifact to be used by a QIIME 2 action (with the exception of metadata).
Most users start with either multiplexed (e.g., between one and three FASTQ files) or demuliplexed (e.g., a collection of `n` `.fastq` files, where `n` is the number of samples, or two-times the number of samples) raw sequence data.
If possible, we recommend starting with demultiplexed sequence data - this prevents you from having to understand how sequences were multiplexed and how they need to be demultiplexed.
Whoever did your sequencing should already have that information and know how to do this.
Others users may start downstream, because some data processing has already been performed. For example, you can also start your QIIME 2 analysis with a feature table (`.biom` or `.tsv` file) generated with some other tool.
[](how-to-import-export) helps you identify what type of data you have, and provides specific instructions on importing different types of data.

Now that we understand that we can actually enter into this overview workflow at nearly *any* of the nodes, let us walk through individual sections.

1. All marker gene sequencing experiments begin, at some point or another, as multiplexed sequence data.
   This is probably in `.fastq` files that containing DNA sequences and quality scores for each base.
1. The sequence data must be demultiplexed, such that each observed sequence read is associated with the sample that it was observed in, or discarded if its sample of origin could not be determined.
1. Reads then undergo quality control (i.e., denoising), and amplicon sequence variants (ASVs) or operational taxonomic units (OTUs) should be defined.
   The goals of these steps are to remove sequencing errors and to dereplicate sequences to make downstream analyses more performant.
   These steps result in:
   a. a feature table that tabulates counts of ASVs (or OTUs) on a per-sample basis, and
   b. feature sequences - a mapping of ASV (or OTU) identifiers to the sequences they represent.

These artifacts (the feature table and feature sequences) are central to most downstream analyses.
Common analyses include:
1. Taxonomic annotation of sequences, which lets you determine with taxa (e.g., species, genera, phyla) are present.
1. Alpha and beta diversity analyses, or measures of diversity within and between samples, respectively.
   These enable assessment of how similar or different samples are to one another.
   Some diversity metrics integrate measures of phylogenetic similarity between individual features.
   If you are sequencing phylogenetic markers (e.g., 16S rRNA genes), you can construct a phylogenetic tree from your feature sequences to use when calculating phylogenetic diversity metrics.
1. Differential abundance testing, to determine which features (OTUs, ASVs, taxa, etc) are significantly more/less abundant in different experimental groups.

This is just the beginning, and [many other statistical tests and plotting methods are at your finger tips in QIIME 2](fun-with-feature-tables) and in the lands beyond.
The world is your oyster.
Let's dive in.
🏊

(conceptual-overview:demultiplexing)=
### Demultiplexing

Okay!
Imagine we have just received some FASTQ data, hot off the sequencing instrument.
Most next-gen sequencing instruments have the capacity to analyze hundreds or even thousands of samples in a single lane/run; we do so by *multiplexing* these samples, which is just a fancy word for mixing a whole bunch of stuff together.
How do we know which sample each read came from?
This is typically done by appending a unique barcode (a.k.a. index or tag) sequence to one or both ends of each sequence.
Detecting these barcode sequences and mapping them back to the samples they belong to allows us to *demultiplex* our sequences.

:::{note}
Whoever did your sequencing may have already demultiplexed your sequences for you, in which case you don't need to demultiplex with QIIME 2.
In our opinion: whoever did the sequencing knows how the sequences were multiplexed and how they should be demultiplexed, so this is something that's easier for them to do than for you to do.

If you are demultiplexing with QIIME 2 (or just want to understand how it works - never a bad thing!), read on.
Otherwise, you can jump to [](conceptual-overview:denoising-and-clustering).
:::

You (or whoever prepared and sequenced your samples) should know which barcode is associated with each sample -- if you do not know, talk to your lab mates or sequencing center.
Include this barcode information in your [sample metadata](https://use.qiime2.org/en/latest/references/metadata.html) file.

The process of demultiplexing (as it occurs in QIIME 2) will look something like {ref}`overview-demux-denoise` (ignore the right-hand side of this flow chart for now).

```{figure} ../_static/overview-demux-denoise.png
:label: overview-demux-denoise
:alt: Flowchart of demultiplexing and denoising workflows in QIIME 2.

Flowchart of demultiplexing and denoising workflows in QIIME 2.
```

This flowchart describes all demultiplexing steps that are currently possible in QIIME 2, depending on the type of raw data you have imported.
Usually only one of the different demultiplexing actions available in `q2-demux` or `q2-cutadapt` will be applicable for your data, and that is all you will need.

Read more about demultiplexing and give it a spin with the [](moving-pictures-tutorial).
That tutorials covers the Earth Microbiome Project format data.

If instead you have barcodes and primers in-line in your reads, see the [cutadapt tutorials](https://forum.qiime2.org/t demultiplexing-and-trimming-adapters-from-reads-with-q2-cutadapt/2313) for using the demux methods in `q2-cutadapt`.

Have dual-indexed reads or mixed-orientation reads or some other unusual format?
Search the [QIIME 2 Forum](https://forum.qiime2.org) for advice.

### Paired-end read joining

If you're working with Illumina paired-end reads, they will typically need to be joined at some point in the analysis.
If you read [](merge-paired-end-reads), you will see that this happens automatically during denoising with `q2-dada2`.
However, if you want to use `q2-deblur` or an OTU clustering method (as described in more detail below), use `q2-vsearch` to join these reads before proceeding, as shown in the {ref}`overview-demux-denoise`.

If you are beginning to pull your hair and foam at the mouth, do not despair: QIIME 2 tends to get easier the further we travel in the "general overview" ({ref}`overview-marker-gene`).
Importing and demultiplexing raw sequencing data happens to be the most frustrating part for most new users because there are so many different ways that marker gene data can be generated.
But once you get the hang of it, it's a piece of cake.
🍰

(conceptual-overview:denoising-and-clustering)=
### Denoising and clustering

Congratulations on getting this far!
Denoising and clustering steps are slightly less confusing than importing and demultiplexing!
🎉😬🎉

The names for these steps are very descriptive:
1. We *denoise* our sequences to remove and/or correct noisy reads.
   🔊
2. We *dereplicate* our sequences to reduce repetition and file size/memory requirements in downstream steps (don't worry! we keep count of each replicate).
   🕵️
3. We (optionally) *cluster* sequences to collapse similar sequences (e.g., those that are ≥ 97% similar to each other) into single replicate sequences.
   This process, also known as *OTU picking*, was once a common procedure, used to simultaneously dereplicate but also perform a sort of quick-and-dirty denoising procedure (to capture stochastic sequencing and PCR errors, which should be rare and similar to more abundant centroid sequences).
   [Skip clustering in favor of denoising, unless you have really strong reason not to.](https://doi.org/10.1038/ismej.2017.119)


#### Denoising

Let's start with denoising, which is depicted on the right-hand side of {ref}`overview-demux-denoise`.

The denoising methods currently available in QIIME 2 include [DADA2](https://doi.org/10.1038/nmeth.3869) and [Deblur](https://doi.org/10.1128/msystems.00191-16).
You can learn more about those methods by reading the original publications for each.
Examples of using both are presented in [](moving-pictures-tutorial).
Note that deblur (and also `vsearch dereplicate-sequences`) should be preceded by [basic quality-score-based filtering](https://doi.org/10.1038/nmeth.2276), but this is unnecessary for DADA2.
Both Deblur and DADA2 contain internal chimera checking methods and abundance filtering, so additional filtering should not be necessary following these methods.
🦁🐐🐍

To put it simply, these methods filter out noisy sequences, correct errors in marginal sequences (in the case of DADA2), remove chimeric sequences, remove singletons, join denoised paired-end reads (in the case of DADA2), and then dereplicate those sequences.
😎

The features produced by denoising methods go by many names, usually some variant of "sequence variant" (SV), "amplicon SV" (ASV), "actual SV", "exact SV"...
We tend to use amplicon sequence variant (ASV) in the QIIME 2 documentation, and we'll stick with that here.
📏

#### Clustering

Next we will discuss clustering methods.
Dereplication (the simplest clustering method, effectively producing 100% OTUs, i.e., all unique sequences observed in the dataset) is also depicted in {ref}`overview-clustering`, and is the necessary starting point to all other clustering methods in QIIME 2 ({ref}`overview-clustering`).

:::{figure} ../_static/overview-clustering.png
:label: overview-clustering
:alt: Flowchart of OTU clustering, chimera filtering, and abundance filtering workflows in QIIME 2.

Flowchart of OTU clustering, chimera filtering, and abundance filtering workflows in QIIME 2.
:::

`q2-vsearch` implements three different [OTU clustering strategies](https://doi.org/10.7717/peerj.545): de novo, closed reference, and open reference.
All should be preceded by [basic quality-score-based filtering](https://doi.org/10.1038/nmeth.2276) and followed by chimera filtering and [aggressive OTU filtering](https://doi.org/10.1038/nmeth.2276) (the treacherous trio, a.k.a. the Bokulich method).
🙈🙉🙊

[](docs/how-to-guides/cluster-reads-into-otus.md) demonstrates use of several `q2-vsearch` clustering methods.
Don't forget to read the [chimera filtering tutorial](https://docs.qiime2.org/2024.10/tutorials/chimera/) as well.

:::{warning}
Clustering methods produce lower-resolution, lower-quality features than the newer denoising/ASV-based approaches.
We recommend against using clustering, but we provide the functionality because there are some cases where it is still relevant.
If you're thinking about including a clustering step in your workflow, reach out on the [QIIME 2 Forum](https://forum.qiime2.org) - we can try to help you figure out an alternative.
:::

## The feature table

The final products of all denoising and clustering methods/workflows are a `FeatureTable` (feature table) artifact and a `FeatureData[Sequence]` (representative sequences) artifact.
These are two of the most important artifact classes in a marker gene sequencing workflow, and are used for many downstream analyses, as discussed below.
Indeed, feature tables are crucial to any QIIME 2 analysis, as the central record of the counts of features per sample.
Such an important artifact deserves its own powerful plugin:

::::{tip} q2-feature-table plugin documentation
:class: dropdown
:::{describe-plugin} feature-table
:::
::::

We will not discuss all actions of this plugin in detail here (some are mentioned below), but it performs many useful operations on feature tables so familiarize yourself with its documentation!

:::{tip} Reviewing information about observed sequences
:label: overview-tabulate-seqs
A very useful pair of actions here are `summarize-plus` and `tabulate-seqs`: when used together, these allow you to generate a summary of which sequences were observed how many times and in how many samples.
See an example from the gut-to-soil axis study [here](https://view.qiime2.org/visualization/?src=https://zenodo.org/api/records/13887457/files/asv-seqs-ms10.qzv/content).
After taxonomically annotating the sequences (coming up next!) you can integrate that information in this report as well.

This is a little advanced, so don't worry if you're not able to answer this yet: referring to the help text of the `summarize-plus` and `tabulate-seqs` actions, which output(s) of `summarize-plus` would be passed as which input(s) to `tabulate-seqs`?
Hint: read about [using Artifacts as metadata](https://use.qiime2.org/en/latest/how-to-guides/artifacts-as-metadata.html) - this is a very powerful concept in QIIME 2, and opens up many diverse analysis possibilities.
:::

Congratulations!
You've made it through importing, demultiplexing, and denoising/clustering your data, which are the most complicated and difficult steps for most users (if only because there are so many ways to do it!).
If you've made it this far, the rest should be easy.
Now begins the fun.
🍾

## Taxonomy classification (or annotation) and taxonomic analyses

For many experiments, investigators aim to identify the organisms that are present in a sample.
For example:
- [How do the genera or species in a system change over time?](https://doi.org/10.48550/arXiv.2411.04148)
- Are there any potential human pathogens in this patient's sample?
- [What's swimming in my wine?](https://doi.org/10.1073/pnas.1317377110) 🍷🤑

We can do this by comparing our feature sequences (be they ASVs or OTUs) to a reference database of sequences with known taxonomic composition.
Simply finding the closest alignment is not really good enough -- because other sequences that are equally close matches or nearly as close may have different taxonomic annotations.
So we use *taxonomy classifiers* to determine the closest taxonomic affiliation with some degree of confidence or consensus (which may not be a species name if one cannot be predicted with certainty!), based on alignment, k-mer frequencies, etc.
Those interested in learning more about the relative performance of the taxonomy classifiers in QIIME 2 can [read until the cows come home](https://doi.org/10.1186/s40168-018-0470-z).
And if you want to learn about how the algorithms work, you can refer to the [*Sequencing Homology Searching*](https://readiab.org/database-searching.html) chapter of [*An Introduction to Applied Bioinformatics*](https://doi.org/10.21105/jose.00027)).
🐄🐄🐄

{ref}`overview-taxonomy` shows what a taxonomy classification workflow might look like.

:::{figure} ../_static/overview-taxonomy.png
:label: overview-taxonomy
:alt: Flowchart of taxonomic annotation workflows in QIIME 2.

Flowchart of taxonomic annotation workflows in QIIME 2.
:::

### Alignment-based taxonomic classification
`q2-feature-classifier` contains three different classification methods.
`classify-consensus-blast` and `classify-consensus-vsearch` are both alignment-based methods that find a consensus assignment across N top hits.
These methods take reference database `FeatureData[Taxonomy]` and `FeatureData[Sequence]` files directly, and do not need to be pre-trained.

### Machine-learning-based taxonomic classification
Machine-learning-based classification methods are available through `classify-sklearn`, and theoretically can apply any of the classification methods available in [scikit-learn](http://scikit-learn.org).
These classifiers must be *trained*, e.g., to learn which features best distinguish each taxonomic group, adding an additional step to the classification process.
Classifier training is **reference database- and marker-gene-specific** and only needs to happen once per marker-gene/reference database combination; that classifier may then be re-used as many times as you like without needing to re-train!

#### Training your own feature classifiers.
If you're working with an uncommon marker gene, you may need to train your own feature classifier.
This is possible following the steps in the [classifier training tutorial](https://docs.qiime2.org/2024.10/tutorials/feature-classifier/).
The [`rescript` plugin](../references/plugin-reference/plugins/rescript) also contains many tools that can be useful in preparing reference data for training classifiers.
Most users don't need to train their own classifiers however, as the QIIME 2 developers [provide classifiers to the public for common marker genes in the QIIME 2 Library](https://resources.qiime2.org).
🎅🎁🎅🎁🎅🎁

#### Environment-weighted classifiers
Typical Naive Bayes classifiers treat all reference sequences as being equally likely to be observed in a sample.
[Environment-weighted taxonomic classifiers](https://doi.org/10.1038/s41467-019-12669-6), on the other hand, use public microbiome data to weight taxa by their past frequency of being observed in specific sample types.
This can improve the accuracy and the resolution of marker gene classification, and we recommend using weighted classifiers when possible.
You can find environment-weighted classifiers [for 16S rRNA in the QIIME 2 Library](https://resources.qiime2.org).
If the environment type that you're studying isn't one of the ones that pre-trained classifiers are provided for, the "diverse weighted" classifiers may still be relevant.
These are trained on weights from multiple different environment types, and have been shown to perform better than classifiers that assume equal weights for all taxa.

### Which feature classification method is best?
[They are all pretty good](https://doi.org/10.1186/s40168-018-0470-z), otherwise we wouldn't bother exposing them in `q2-feature-classifier`.
But in general `classify-sklearn` with a Naive Bayes classifier can slightly outperform other methods we've tested based on several criteria for classification of 16S rRNA gene and fungal ITS sequences.
It can be more difficult and frustrating for some users, however, since it requires that additional training step.
That training step can be memory intensive, becoming a barrier for some users who are unable to use the pre-trained classifiers.
Some users also prefer the alignment-based methods because their mode of operation is much more transparent and their parameters easier to manipulate.

### Feature classification can be slow
Runtime of feature classifiers is a function of the number of sequences to be classified, and the number of reference sequences.
If runtime is an issue for you, considering filtering low-abundance features out of your sequences file before classifying (e.g., those that are present in only a single sample), and use smaller reference databases if possible.
In practice, in "normal size" sequencing experiments (whatever that means 😜) we see variations between a few minutes (a few hundred features) to hours or days (hundreds of thousands of features) for classification to complete.
If you want to hang some numbers on there, [check out our benchmarks](https://doi.org/10.1186/s40168-018-0470-z) for classifier runtime performance.
🏃⏱️

### Feature classification can be memory intensive
Generally at least 8 GB of RAM are required, though 16GB is better.
The is generally related to the size of the reference database, and in some cases 32 GB of RAM or more are required.

Examples of using `classify-sklearn` are shown in the [](moving-pictures-tutorial).
{ref}`overview-taxonomy` should make the other classifier methods reasonably clear.

All classifiers produce a `FeatureData[Taxonomy]` artifact, tabulating the taxonomic annotation for each query sequence.
If you want to review those, or compare them across different classifiers, refer back to [](overview-tabulate-seqs).

### Taxonomic analysis

Taxonomic classification opens us up to a whole new world of possibilities. 🌎

Here are some popular actions that are enabled by having a `FeatureData[Taxonomy]` artifact:

1. **Collapse your feature table** with `taxa collapse`!
   This groups all features that share the same taxonomic assignment into a single feature.
   That taxonomic assignment becomes the feature ID in the new feature table.
   This feature table [can be used in all the same ways as the original](fun-with-feature-tables).
   Some users may be specifically interested in performing, e.g., taxonomy-based diversity analyses, but at the very least anyone assigning taxonomy is probably interested in assessing [differential abundance](overview-differential-abundance) of those taxa.
   Comparing differential abundance analyses using taxa as features versus using ASVs or OTUs as features can be diagnostic and informative for various analyses.
1. **Plot your taxonomic composition** to see the abundance of various taxa in each of your samples.
   Check out `taxa barplot` and `feature-table heatmap` for more details. 📊
1. **Filter your feature table and feature sequences** to remove certain taxonomic groups.
   This is useful for removing known contaminants or non-target groups, e.g., host DNA including mitochondrial or chloroplast sequences.
   It can also be useful for focusing on specific groups for deeper analysis.
   See the [filtering tutorial](https://docs.qiime2.org/2024.10/tutorials/filtering/) for more details and examples. 🌿🐀

## Sequence alignment and phylogenetic reconstruction

Some diversity metrics - notably [Faith's Phylogenetic Diversity (PD)](https://doi.org/10.1016/0006-3207(92)91201-3) and [UniFrac](https://doi.org/10.1128/AEM.71.12.8228-8235.2005) - integrate the phylogenetic similarity of features.
If you are sequencing phylogenetic markers (e.g., 16S rRNA genes), you can build a phylogenetic tree that can be used for computing these metrics.

The different options for aligning sequences and producing a phylogeny are shown in the flowchart below, and can be classified as *de novo* or reference-based.
For a detailed discussion of alignment and phylogeny building, see the [q2-phylogeny tutorial](https://docs.qiime2.org/2024.10/tutorials/phylogeny/) and [q2-fragment-insertion](https://doi.org/10.1128/mSystems.00021-18).
🌳

:::{figure} ../_static/overview-alignment-phylogeny.png
:label: overview-alignment-phylogeny
:alt: Flowchart of alignment and phylogenetic reconstruction workflows in QIIME 2.

Flowchart of alignment and phylogenetic reconstruction workflows in QIIME 2.
:::

Now that we have our rooted phylogenetic tree (i.e., an artifact of class `Phylogeny[Rooted]`), let's use it!

## Diversity analysis

In microbiome experiments, investigators frequently wonder about things like:

- How many different species/OTUs/ASVs are present in my samples?
- Which of my samples represent more phylogenetic diversity?
- Does the microbiome composition of my samples differ based on sample categories (e.g., healthy versus disease)?
- What factors (e.g., pH, elevation, blood pressure, body site, or host species just to name a few examples) are correlated with differences in microbial composition and biodiversity?

These questions can be answered by alpha- and beta-diversity analyses.
Alpha diversity measures the level of diversity within individual samples.
Beta diversity measures assess the dissimilarity between samples.
We can then use this information to statistically test whether alpha diversity is different between groups of samples (indicating, for example, that those groups have more/less species richness) and whether beta diversity is greater across groups (indicating, for example, that samples within a group are more similar to each other than those in another group, suggesting that membership within these groups is shaping the microbial composition of those samples).

Different types of diversity analyses in QIIME 2 are exemplified in the [](moving-pictures-tutorial).
The actions used to generate diversity artifacts are shown in {ref}`overview-diversity`, and many other tools can operate on these results.

:::{figure} ../_static/overview-diversity.png
:label: overview-diversity
:alt: Flowchart of diversity analysis workflows in QIIME 2.

Flowchart of diversity analysis workflows in QIIME 2.
:::

The `q2-diversity` plugin contains many different useful actions.
Check them out to learn more.
As you can see in the flowchart, the `diversity core-metrics*` pipelines (`core-metrics` and `core-metrics-phylogenetic`) encompass many different core diversity commands, and in the process produce the main diversity-related artifacts that can be used in downstream analyses.
These are:
- `SampleData[AlphaDiversity]` artifacts, which contain alpha diversity estimates for each sample in your feature table.
  This is the chief artifact for alpha diversity analyses.
- `DistanceMatrix` artifacts, containing the pairwise distance/dissimilarity between each pair of samples in your feature table.
  This is the chief artifact for beta diversity analyses.
- `PCoAResults` artifacts, containing principal coordinates ordination results for each distance/dissimilarity metric.
  Principal coordinates analysis is a dimension reduction technique, facilitating visual comparisons of sample (dis)simmilarities in 2D or 3D space.
  Learn more about ordination in [*Ordination Methods for Ecologists*](https://ordination.okstate.edu/) and in the [*Machine learning in bioinformatics*](https://readiab.org/machine-learning.html) section of *An Introduction to Applied Bioinformatics*](https://doi.org/10.21105/jose.00027).

:::{tip} q2-boots: bootstrapped and rarefaction-based microbiome diversity analysis
A {term}`stand-alone plugin`, [`q2-boots`](https://library.qiime2.org/plugin/caporaso-lab/q2-boots) has recently (as of March 2025) been released that facilitates bootstrapped and rarefaction-based diversity analysis.
The actions in this plugin are intended to mirror those in `q2-diversity`, and the results are more robust than those generated by `q2-diversity` because they integrate all of the observed microbiome data.
To learn more about this, refer to [Raspet *et al.* (2025)](https://doi.org/10.12688/f1000research.156295.1).
The artifacts generated by `q2-boots` are intended to be used anywhere that the artifacts generated by `q2-diversity` are used.

Some optimization of the methods in this plugin is still in progress, and as a result this isn't yet part of the amplicon distribution.
It can however be installed on top of the amplicon distribution following [its install instructions on the QIIME 2 Library](https://library.qiime2.org/plugin/caporaso-lab/q2-boots).
Try it out!
🥾
:::

These are the main diversity-related artifacts.
We can re-use these data in [all sorts of downstream analyses](fun-with-feature-tables), or in the various actions of `q2-diversity` shown in the flowchart.
Many of these actions are demonstrated in the [](moving-pictures-tutorial) so head on over there to learn more!

Note that there are [many different alpha- and beta-diversity metrics](https://forum.qiime2.org/t/alpha-and-beta-diversity-explanations-and-commands/2282) that are available in QIIME 2.
To learn more (and figure out whose paper you should be citing!), check out that neat resource, which was contributed by a friendly QIIME 2 user to enlighten all of us.
Thanks Stephanie!
😁🙏😁🙏😁🙏

(fun-with-feature-tables)=
## Fun with feature tables

At this point you have a feature table, taxonomy classification results, alpha diversity, and beta diversity results.
Oh my!
🦁🐯🐻

Taxonomic and diversity analyses, as described above, are the basic types of analyses that most QIIME 2 users are probably going to need to perform at some point.
However, this is only the beginning, and there are so many more advanced analyses at our fingertips.
🖐️⌨️

:::{figure} ../_static/overview-fun-with-features.png
:label: overview-fun-with-features
:alt: Flowchart of "downstream" analysis workflows in QIIME 2.

Flowchart of "downstream" analysis workflows in QIIME 2.
**Note: [This figure needs some updates](https://github.com/qiime2/amplicon-docs/issues/7).
Specifically, gneiss was deprecated and is no longer part of the *amplicon distribution*.
:::

We are only going to give a brief overview, since each of these analyses
has its own in-depth tutorial to guide us:

- **Analyze longitudinal data:**
  `q2-longitudinal` is a plugin for performing statistical analyses of [longitudinal experiments](https://en.wikipedia.org/wiki/Longitudinal_study), i.e., where samples are collected from individual patients/subjects/sites repeatedly over time.
  This includes longitudinal studies of alpha and beta diversity, and some really awesome, interactive plots.
📈🍝
 - **Predict the future (or the past) 🔮:**
   `q2-sample-classifier` is a plugin for machine-learning 🤖 analyses of feature data.
   Both classification and regression models are supported.
   This allows you to do things like:
 - predict sample metadata as a function of feature data (e.g., can we use a fecal sample to [predict cancer susceptibility](https://dx.doi.org/10.1128%2FmSphere.00001-15)?
   Or [predict wine quality](https://doi.org/10.1128/mbio.00631-16) based on the microbial composition of grapes before fermentation?).
   🍇
 - identify features that are predictive of different sample characteristics.
   🚀
 - quantify rates of microbial maturation (e.g., to track normal microbiome development in the infant gut and the impacts of [persistent malnutrition](https://dx.doi.org/10.1038%2Fnature13421) or [antibiotics, diet, and delivery mode](https://dx.doi.org/10.1126%2Fscitranslmed.aad7121)).
   👶
 - predict outliers and [mislabeled samples](https://dx.doi.org/10.1038%2Fismej.2010.148).
   👹

- **Differential abundance** testing is used to determine which features are significantly more/less abundant in different groups of samples.
  QIIME 2 currently supports a few different approaches to  differential abundance testing, including `ancom-bc` in `q2-composition`.
  👾👾👾

- **Evaluate and control data quality:**
  `q2-quality-control` is a plugin for evaluating and controlling sequence data quality.
  This includes actions that:
 - test the accuracy of different bioinformatic or molecular methods, or of run-to-run quality variation.
   These actions are typically used if users have samples with known compositions, e.g., [mock communities](http://mockrobiota.caporasolab.us/), since accuracy is calculated as the similarity between the observed and expected compositions, sequences, etc.
   But more creative uses may be possible...
 - filter sequences based on alignment to a reference database, or that contain specific short sections of DNA (e.g., primer sequences).
   This is useful for removing sequences that match a specific group of organisms, non-target DNA, or other nonsense.
   🙃

And that's just a brief overview!
QIIME 2 continues to grow, so stay tuned for more plugins in future releases 📻, and keep your [eyes peeled](https://library.qiime2.org) for {term}`stand-alone plugins <stand-alone plugin>` that will continue to expand the functionality availability in QIIME 2.

A good next step is to work through the [](moving-pictures-tutorial), if you haven't done so already.
That will help you learn how to actually use all of the functionality discussed here on real microbiome sequence data.

Now go forth an have fun!
💃
