(infer-phylogenies)=
# How to infer phylogenies with `q2-phylogeny` and `q2-fragment-insertion`

:::{note}
This guide assumes you've read through the [conceptual overview](#conceptual-overview) and have at least worked through one of the tutorials, such as the [](#gut-to-soil-tutorial).
:::

## Inferring phylogenies

Several downstream diversity metrics, available within [QIIME 2](https://qiime2.org), require that a phylogenetic tree be constructed using the Operational Taxonomic Units ([OTUs](https://en.wikipedia.org/wiki/Operational_taxonomic_unit)) or Amplicon Sequence Variants ([ASVs](https://doi.org/10.1128/mSystems.00191-16)) being investigated.

*But how do we proceed to construct a phylogeny from our sequence data?*

Well, there are two phylogeny-based approaches we can use.
Deciding upon which to use is largely dependent on your study questions:

1. A reference-based [fragment insertion](https://doi.org/10.1128/mSystems.00021-18) approach.
   Which, is likely the ideal choice.
   Especially, if your reference phylogeny (and associated representative sequences) encompass neighboring relatives of which your sequences can be reliably inserted.
   Any sequences that do not match well enough to the reference are not inserted.
   For example, this approach may not work well if your data contain sequences that are not well represented within your reference phylogeny (e.g. missing clades, etc.).
   For an example, see [](#infer-phylogenies-fragment-insertion) below.

2. A *de novo* approach.
   Marker genes that can be globally aligned across divergent taxa, are usually amenable to sequence alignment and phylogenetic investigation through this approach.
   Be mindful of the length of your sequences when constructing a *de novo* phylogeny, short reads may not have enough phylogenetic information to capture a meaningful phylogeny.
   This guide will focus on the *de novo* approaches, and ends with an example of fragment insertion.

Here, you will learn how to make use of *de novo* phylogenetic approaches to:

1. generate a sequence alignment within QIIME 2
2. mask the alignment if needed
3. construct a phylogenetic tree
4. root the phylogenetic tree

If you would like to substitute any of the steps outlined here by making use of tools external to QIIME 2, please see the [import](#how-to-import) and [export](#how-to-export) documentation where appropriate.

### Sequence Alignment

Prior to constructing a [phylogeny](https://simple.wikipedia.org/wiki/Phylogeny) we must generate a multiple sequence alignment ([MSA](https://en.wikipedia.org/wiki/Multiple_sequence_alignment)).
When constructing a MSA we are making a statement about the [putative homology](https://doi.org/10.1006/mpev.2000.0785) of the aligned residues (columns of the MSA) by virtue of their [sequence similarity](https://doi.org/10.1002/0471250953.bi0301s42).

The number of algorithms to construct a MSA are legion.
We will make use of [MAFFT](https://en.wikipedia.org/wiki/MAFFT) (Multiple Alignment using Fast Fourier Transform) via the [q2-alignment](#q2-plugin-alignment) [plugin](xref:rachis-glossary-target#term-plugin).
For more information checkout the [MAFFT paper](https://doi.org/10.1093/molbev/mst010).

First, download the data:

:::{describe-usage}
:scope: infer-phylogenies

rep_seqs = use.init_artifact_from_url(
    'rep-seqs',
    'https://data.qiime2.org/2025.4/tutorials/phylogeny/rep-seqs.qza')
:::

**Run MAFFT**

:::{describe-usage}

aligned_rep_seqs, = use.action(
    use.UsageAction(plugin_id='alignment',
                    action_id='mafft'),
    use.UsageInputs(sequences=rep_seqs),
    use.UsageOutputNames(alignment='aligned-rep-seqs'))
:::

### Reducing alignment ambiguity: masking and reference alignments

*Why mask an alignment?*

Masking helps to eliminate alignment columns that are phylogenetically uninformative or misleading before phylogenetic analysis.
Much of the time alignment errors can introduce noise and confound phylogenetic inference.
It is common practice to mask (remove) these ambiguously aligned regions prior to performing phylogenetic inference.
In particular, [David Lane's (1991)](http://www.worldcat.org/title/nucleic-acid-techniques-in-bacterial-systematics/oclc/22310197) chapter [16S/23S rRNA sequencing](https://catdir.loc.gov/catdir/toc/onix05/90012998.html) proposed masking SSU data prior to phylogenetic analysis.
However, knowing how to deal with ambiguously aligned regions and when to apply masks largely depends on the marker genes being analyzed and the question being asked of the data.

:::{note}
Keep in mind that this is still an active area of discussion, as highlighted by the following non-exhaustive list of articles: [Wu *et al*. 2012](https://doi.org/10.1371/journal.pone.0030288), [Ashkenazy *et al*. 2018](https://doi.org/10.1093/sysbio/syy036), [Schloss 2010](https://doi.org/10.1371/journal.pcbi.1000844), [Tan *et al*. 2015](https://doi.org/10.1093/sysbio/syv033), [Rajan 2015](https://doi.org/10.1093/molbev/mss264).
:::

*How to mask alignment.*

For our purposes, we'll assume that we have ambiguously aligned columns in the MAFFT alignment we produced above.
The default settings for the `--p-min-conservation` of the [alignment mask](#q2-action-alignment-mask) approximates the Lane mask filtering of QIIME 1.
Keep an eye out for updates to the alignment plugin.

:::{describe-usage}

masked_aligned_rep_seqs, = use.action(
    use.UsageAction(plugin_id='alignment',
                    action_id='mask'),
    use.UsageInputs(alignment=aligned_rep_seqs),
    use.UsageOutputNames(masked_alignment='masked-aligned-rep-seqs'))
:::

*Reference based alignments*

There are several tools that attempt to reduce the amount of ambiguously aligned regions by using curated reference alignments.
Traditional, de novo alignment methods mutually align a set of unaligned sequences to create a multiple sequence alignment (MSA) from scratch.
Re-running these methods with additional sequences will create MSAs with varying numbers of columns and assignments of bases to each column.
These alignments are therefore incompatible with one another and may not be joined through concatenation.

Reference based alignments, on the other hand, are meant to add sequences to an existing alignment.
Alignments computed using reference based alignment tools always have widths identical to the reference alignment and maintain the meaning of each column.
Therefore, these alignments may be concatenated.

QIIME 2 currently does not wrap any methods for reference-based alignments, but alignments created using these methods can be imported into QIIME 2 as `FeatureData[AlignedSequence]` artifacts, provided that the alignments are standard FASTA formats.
Some examples of tools for reference-based alignment include [PyNAST](https://doi.org/10.1093/bioinformatics/btp636) (using [NAST](https://doi.org/10.1093/nar/gkl244)), [Infernal](https://doi.org/10.1093/bioinformatics/btt509), and [SINA](https://doi.org/10.1093/bioinformatics/bts252).
[SILVA](https://www.arb-silva.de/) Reference alignments are particularly powerful for rRNA gene sequence data, as knowledge of secondary structure is incorporated into the curation process, thus increasing alignment quality.

:::{note}
Alignments constructed using reference based alignment approaches can be masked too, just like the above MAFFT example.
Also, the reference alignment approach we are discussing here is distinct from the reference phylogeny approach (i.e. [q2-fragment-insertion](#q2-plugin-fragment-insertion)) we mentioned earlier.
That is, we are not inserting our data into an existing tree, but simply trying to create a more robust alignment for making a better *de novo* phylogeny.
:::

### Construct a phylogeny

As with MSA algorithms, phylogenetic inference tools are also legion.
Fortunately, there are many great resources to learn about phylogenetics.
Below are just a few introductory resources to get you started:

1. [Phylogeny for the faint of heart - a tutorial](https://doi.org/10.1016/S0168-9525(03)00112-4)
2. [Molecular phylogenetics - principles and practice](https://doi.org/10.1038/nrg3186)
3. [Phylogenetics - An Introduction](https://www.ebi.ac.uk/training/online/courses/introduction-to-phylogenetics/)

There are several methods / pipelines available through the [q2-phylogeny](#q2-plugin-phylogeny) plugin of QIIME 2.
These are based on the following tools:

1. [FastTree](https://doi.org/10.1371/journal.pone.0009490)
2. [RAxML](https://doi.org/10.1093/bioinformatics/btu033)
3. [IQ-TREE](https://doi.org/10.1093/molbev/msu300)

## Methods

### fasttree

FastTree is able to construct phylogenies from large sequence alignments quite rapidly.
It does this by using a [CAT-like](https://doi.org/10.1109/IPDPS.2006.1639535) rate category approximation, which is also available through RAxML (discussed below).
Check out the [FastTree online manual](https://microbesonline.org/fasttree/) for more information.

:::{describe-usage}

fasttree_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='fasttree'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs),
    use.UsageOutputNames(tree='fasttree-tree'))
:::

:::{tip}
For an easy and direct way to view your `tree.qza` files, upload them to [iTOL](https://itol.embl.de/).
Here, you can interactively view and manipulate your phylogeny.
Even better, while viewing the tree topology in "Normal mode", you can drag and drop your associated `alignment.qza` (the one you used to build the phylogeny) or a relevant `taxonomy.qza` file onto the iTOL tree visualization.
This will allow you to directly view the sequence alignment or taxonomy alongside the phylogeny.
🕶️
:::

### raxml

Like `fasttree`, `raxml` will perform a single phylogenetic inference and return a tree.
Note, the default model for `raxml` is `--p-substitution-model GTRGAMMA`.
If you'd like to construct a tree using the CAT model like `fasttree`, simply replace `GTRGAMMA` with `GTRCAT` as shown below:

:::{describe-usage}

raxml_cat_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='raxml'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    substitution_model='GTRCAT'),
    use.UsageOutputNames(tree='raxml-cat-tree'))
:::

#### Perform multiple searches using raxml

If you'd like to perform a more thorough search of "tree space" you can instruct `raxml` to perform multiple independent searches on the full alignment by using `--p-n-searches 5`.
Once these 5 independent searches are completed, only the single best scoring tree will be returned.
*Note, we are not bootstrapping here, we'll do that in a later example.*
Let's set `--p-substitution-model GTRCAT`.
Finally, let's also manually set a seed via `--p-seed`.
By setting our seed, we allow other users the ability to reproduce our phylogeny.
That is, anyone using the same sequence alignment and substitution model, will generate the same tree as long as they set the same seed value.
Although, `--p-seed` is not a required argument, it is generally a good idea to set this value.

:::{describe-usage}

raxml_cat_searches_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='raxml'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    substitution_model='GTRCAT',
                    seed=1723,
                    n_searches=5),
    use.UsageOutputNames(tree='raxml-cat-searches-tree'))
:::

### raxml-rapid-bootstrap

In phylogenetics, it is good practice to check how well the [splits / bipartitions](https://en.wikipedia.org/wiki/Split_(phylogenetics)) in your phylogeny are supported.
Often one is interested in which clades are robustly separated from other clades in the phylogeny.
One way, of doing this is via bootstrapping (See the *Bootstrapping* section of the first introductory link above).
In QIIME 2, we've provided access to the RAxML [rapid bootstrap](https://doi.org/10.1080/10635150802429642) feature.
The only difference between this command and the previous are the additional flags `--p-bootstrap-replicates` and `--p-rapid-bootstrap-seed`.
It is quite common to perform anywhere from 100 - 1000 bootstrap replicates.
The `--p-rapid-bootstrap-seed` works very much like the `--p-seed` argument from above except that it allows anyone to reproduce the bootstrapping process and the associated supports for your splits.

As per the [RAxML online documentation](https://cme.h-its.org/exelixis/web/software/raxml/hands_on.html) and the [RAxML manual](https://cme.h-its.org/exelixis/resource/download/NewManual.pdf), the rapid bootstrapping command that we will execute below will do the following:

1. Bootstrap the input alignment 100 times and perform a Maximum Likelihood (ML) search on each.
2. Find best scoring ML tree through multiple independent searches using the original input alignment.
   The number of independent searches is determined by the number of bootstrap replicates set in the 1st step.
   That is, your search becomes more thorough with increasing bootstrap replicates.
   The ML optimization of RAxML uses every 5th bootstrap tree as the starting tree for an ML search on the original alignment.
3. Map the bipartitions (bootstrap supports, 1st step) onto the best scoring ML tree (2nd step).

:::{describe-usage}

raxml_cat_bootstrap_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='raxml_rapid_bootstrap'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    seed=1723,
                    rapid_bootstrap_seed=9384,
                    bootstrap_replicates=100,
                    substitution_model='GTRCAT'),
    use.UsageOutputNames(tree='raxml-cat-bootstrap-tree'))
:::

:::{tip}
**Optimizing RAxML Run Time.**
You may have noticed that we haven't added the flag `--p-raxml-version` to the RAxML methods.
This parameter provides a means to access versions of RAxML that have optimized vector instructions for various modern x86 processor architectures.
Paraphrased from the RAxML manual and help documentation: Firstly, most recent processors will support SSE3 vector instructions (i.e. will likely support the faster AVX2 vector instructions).
Secondly, these instructions will substantially accelerate the likelihood and parsimony computations.
In general, SSE3 versions will run approximately 40% faster than the standard version.
The AVX2 version will run 10-30% faster than the SSE3 version.
Additionally, keep in mind that using more cores / threads will not necessarily decrease run time.
The RAxML manual suggests using 1 core per ~500 DNA alignment patterns.
Alignment pattern information is usually visible on screen, when the `--verbose` option is used.
Additionally, try using a rate category (CAT model; via `--p-substitution-model`), which results in equally good trees as the GAMMA models and is approximately 4 times faster.
See the [CAT paper](https://doi.org/10.1109/IPDPS.2006.1639535).
The CAT approximation is also ideal for alignments containing [10,000 or more taxa](https://doi.org/10.1186/1471-2105-12-470), and is very much similar to the [CAT-like model of FastTree2](https://doi.org/10.1371/journal.pone.0009490).
:::

### iqtree

Similar to the `raxml` and `raxml-rapid-bootstrap` methods above, we provide similar functionality for [IQ-TREE](https://doi.org/10.1093/molbev/msu300): `iqtree` and `iqtree-ultrafast-bootstrap`.
IQ-TREE is unique compared to the `fasttree` and `raxml` options, in that it provides access to 286 [models of nucleotide substitution](https://doi.org/10.1016/j.dci.2004.07.007)!
IQ-TREE can also determine which of these models best fits your dataset prior to constructing your tree via its built-in [ModelFinder](https://doi.org/10.1038/nmeth.4285) algorithm.
This is the default in QIIME 2, but do not worry, you can set any one of the 286 models of nucleotide substitution via the `--p-substitution-model` flag, e.g. you can set the model as `HKY+I+G` instead of the default `MFP` (a basic short-hand for: "build a phylogeny after determining the best fit model as determined by ModelFinder").
Keep in mind the additional computational time required for model testing via ModelFinder.

The simplest way to run the [iqtree command](#q2-action-phylogeny-iqtree) with default settings and automatic model selection (`MFP`) is like so:

:::{describe-usage}

iqt_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs),
    use.UsageOutputNames(tree='iqt-tree'))
:::

#### Specifying a substitution model

We can also set a substitution model of our choosing.
You may have noticed while watching the onscreen output of the previous command that the best fitting model selected by ModelFinder is noted.
For the sake of argument, let's say the best selected model was shown as `GTR+F+I+G4`.
The `F` is only a notation to let us know that *if* a given model supports *unequal base frequencies*, then the *empirical base frequencies* will be used by default.
Using empirical base frequencies (`F`), rather than estimating them, greatly reduces computational time.
The `iqtree` plugin will not accept `F` within the model notation supplied at the command line, as this will always be implied automatically for the appropriate model.
Also, the `iqtree` plugin only accepts `G` *not* `G4` to be specified within the model notation.
The `4` is simply another explicit notation to remind us that four rate categories are being assumed by default.
The notation approach used by the plugin simply helps to retain simplicity and familiarity when supplying model notations on the command line.
So, in brief, we only have to type `GTR+I+G` as our input model:

:::{describe-usage}

iqt_gtrig_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    substitution_model='GTR+I+G'),
    use.UsageOutputNames(tree='iqt-gtrig-tree'))
:::

Let's rerun the command above and add the `--p-fast` option.
This option, only compatible with the `iqtree` method, resembles the fast search performed by `fasttree`.
🏎️
Secondly, let's also perform multiple tree searches and keep the best of those trees (as we did earlier with the `raxml --p-n-searches ...` command):

:::{describe-usage}

iqt_gtrig_fast_ms_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    substitution_model='GTR+I+G',
                    fast=True,
                    n_runs=10),
    use.UsageOutputNames(tree='iqt-gtrig-fast-ms-tree'))
:::

#### Single branch tests

IQ-TREE provides access to a few [single branch testing methods](http://www.iqtree.org/doc/Tutorial#assessing-branch-supports-with-single-branch-tests)

1. [SH-aLRT](https://doi.org/10.1093/sysbio/syq010) via `--p-alrt [INT >= 1000]`
2. [aBayes](https://doi.org/10.1093/sysbio/syr041) via `--p-abayes [TRUE | FALSE]`
3. [local bootstrap test](https://doi.org/10.1007/BF02498640) via `--p-lbp [INT >= 1000]`

Single branch tests are commonly used as an alternative to the bootstrapping approach we've discussed above, as they are substantially faster and [often recommended](http://www.iqtree.org/doc/Command-Reference#single-branch-tests) when constructing large phylogenies (e.g. >10,000 taxa).
All three of these methods can be applied simultaneously and viewed within [iTOL](https://itol.embl.de/) as separate bootstrap support values.
These values are always listed in the following order of *alrt / lbp / abayes*.
We'll go ahead and apply all of the branch tests in our next command, while specifying the same substitution model as above.
Feel free to combine this with the `--p-fast` option.
😉

:::{describe-usage}

iqt_sbt_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    alrt=1000,
                    abayes=True,
                    lbp=1000,
                    substitution_model='GTR+I+G'),
    use.UsageOutputNames(tree='iqt-sbt-tree'))
:::

:::{tip}
**IQ-TREE search settings**.
There are quite a few adjustable parameters available for `iqtree` that can be modified to improve searches through "tree space" and prevent the search algorithms from getting stuck in local optima.
One particular [best practice](https://groups.google.com/forum/#!searchin/iqtree/iterations|sort:date/iqtree/0mwGhDokNns/vlBryIwXHAAJ) to aid in this regard, is to adjust the following parameters: `--p-perturb-nni-strength` and `--p-stop-iter` (each respectively maps to the `-pers` and `-nstop` flags of `iqtree` ).
In brief, the larger the value for NNI (nearest-neighbor interchange) perturbation, the larger the jumps in "tree space".
This value should be set high enough to allow the search algorithm to avoid being trapped in local optima, but not too high that the search is haphazardly jumping around "tree space".
That is, like Goldilocks and the three 🐻s you need to find a setting that is "just right", or at least within a set of reasonable bounds.
One way of assessing this, is to do a few short trial runs using the `--verbose` flag.
If you see that the likelihood values are jumping around too much, then lowering the value for `--p-perturb-nni-strength` may be warranted.
As for the stopping criteria, i.e. `--p-stop-iter`, the higher this value, the more thorough your search in "tree space".
Be aware, increasing this value may also increase the run time.
That is, the search will continue until it has sampled a number of trees, say 100 (default), without finding a better scoring tree.
If a better tree is found, then the counter resets, and the search continues.
These two parameters deserve special consideration when a given data set contains many short sequences, quite common for microbiome survey data.
We can modify our original command to include these extra parameters with the recommended modifications for short sequences, i.e. a lower value for perturbation strength (shorter reads do not contain as much phylogenetic information, thus we should limit how far we jump around in "tree space") and a larger number of stop iterations.
See the [IQ-TREE command reference](http://www.iqtree.org/doc/Command-Reference) for more details about default parameter settings.
Finally, we'll let `iqtree` perform the model testing, and automatically determine the optimal number of CPU cores to use.
:::

:::{describe-usage}

iqt_nnisi_fast_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    perturb_nni_strength=0.2,
                    stop_iter=200,
                    n_cores=1),
    use.UsageOutputNames(tree='iqt-nnisi-fast-tree'))
:::

### iqtree-ultrafast-bootstrap

As per our discussion in the `raxml-rapid-bootstrap` section above, we can also use IQ-TREE to evaluate how well our splits / bipartitions are supported within our phylogeny via the [ultrafast bootstrap algorithm](https://doi.org/10.1093/molbev/msx281).
Below, we'll apply the plugin's [ultrafast bootstrap command](#q2-action-phylogeny-iqtree-ultrafast-bootstrap): automatic model selection (`MFP`), perform `1000` bootstrap replicates (minimum required), set the same generally suggested parameters for constructing a phylogeny from short sequences, and automatically determine the optimal number of CPU cores to use:

:::{describe-usage}

iqt_nnisi_bootstrap_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree_ultrafast_bootstrap'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    perturb_nni_strength=0.2,
                    stop_iter=200,
                    n_cores=1),
    use.UsageOutputNames(tree='iqt-nnisi-bootstrap-tree'))
:::

#### Perform single branch tests alongside ufboot

We can also apply single branch test methods concurrently with ultrafast bootstrapping.
The support values will always be represented in the following order: *alrt / lbp / abayes / ufboot*.
Again, these values can be seen as separately listed bootstrap values in [iTOL](https://itol.embl.de/).
We'll also specify a model as we did earlier.

:::{describe-usage}

iqt_nnisi_bootstrap_sbt_gtrig_tree, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='iqtree_ultrafast_bootstrap'),
    use.UsageInputs(alignment=masked_aligned_rep_seqs,
                    perturb_nni_strength=0.2,
                    stop_iter=200,
                    n_cores=1,
                    alrt=1000,
                    abayes=True,
                    lbp=1000,
                    substitution_model='GTR+I+G'),
    use.UsageOutputNames(tree='iqt-nnisi-bootstrap-sbt-gtrig-tree'))
:::

:::{tip}
If there is a need to reduce the impact of [potential model violations](http://www.iqtree.org/doc/Tutorial#reducing-impact-of-severe-model-violations-with-ufboot) that occur during a [UFBoot search](https://doi.org/10.1093/molbev/msx281), and / or would simply like to be more rigorous, we can add the `--p-bnni` option to any of the `iqtree-ultrafast-bootstrap` commands above.
:::

### Root the phylogeny

In order to make proper use of diversity metrics such as UniFrac, the phylogeny must be [rooted](https://www.ebi.ac.uk/training/online/courses/introduction-to-phylogenetics/what-is-a-phylogeny/aspects-of-phylogenies/root/).
Typically an [outgroup](http://phylobotanist.blogspot.com/2015/01/how-to-root-phylogenetic-tree-outgroup.html) is chosen when rooting a tree.
In general, phylogenetic inference tools using Maximum Likelihood often return an unrooted tree by default.

QIIME 2 provides a way to [mid-point root](#q2-action-phylogeny-midpoint-root) our phylogeny.
Other rooting options may be available in the future.
For now, we'll root our bootstrap tree from `iqtree-ultrafast-bootstrap` like so:

:::{describe-usage}

iqt_nnisi_bootstrap_sbt_gtrig_tree_rooted, = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='midpoint_root'),
    use.UsageInputs(tree=iqt_nnisi_bootstrap_sbt_gtrig_tree),
    use.UsageOutputNames(rooted_tree='iqt-nnisi-bootstrap-sbt-gtrig-tree-rooted'))
:::

:::{tip}
**iTOL viewing Reminder**.
We can view our tree and its associated alignment via [iTOL](https://itol.embl.de/).
All you need to do is upload the `iqt-nnisi-bootstrap-sbt-gtrig-tree-rooted.qza` tree file.
Display the tree in *Normal* mode.
Then drag and drop the `masked-aligned-rep-seqs.qza` file onto the visualization.
Now you can view the phylogeny alongside the alignment.
:::

## Pipelines

Here we will outline the use of the phylogeny [pipeline](xref:rachis-glossary-target#term-pipeline) [align-to-tree-mafft-fasttree](#q2-action-phylogeny-align-to-tree-mafft-fasttree).

One advantage of pipelines is that they combine ordered sets of commonly used commands, into one condensed simple command.
To keep these "convenience" pipelines easy to use, it is quite common to only expose a few options to the user.
That is, most of the commands executed via pipelines are often configured to use default option settings.
However, options that are deemed important enough for the user to consider setting, are made available.
The options exposed via a given pipeline will largely depend upon what it is doing.
Pipelines are also a great way for new users to get started, as it helps to lay a foundation of good practices in setting up standard operating procedures.

Rather than run one or more of the following QIIME 2 commands listed below:

1. `qiime alignment mafft ...`
2. `qiime alignment mask ...`
3. `qiime phylogeny fasttree ...`
4. `qiime phylogeny midpoint-root ...`

We can make use of the pipeline [align-to-tree-mafft-fasttree](#q2-action-phylogeny-align-to-tree-mafft-fasttree) to automate the above four steps in one go.
Here is the description taken from the pipeline help doc:

> This pipeline will start by creating a sequence alignment using MAFFT, after which any alignment columns that are phylogenetically uninformative or ambiguously aligned will be removed (masked).
> The resulting masked alignment will be used to infer a phylogenetic tree and then subsequently rooted at its midpoint.
> Output files from each step of the pipeline will be saved.
> This includes both the unmasked and masked MAFFT alignment from q2-alignment methods, and both the rooted and unrooted phylogenies from q2-phylogeny methods.

This can all be accomplished by simply running the following:

:::{describe-usage}

(mafft_fasttree_alignment, mafft_fasttree_masked_alignment,
 mafft_fasttree_tree, mafft_fasttree_rooted_tree) = use.action(
    use.UsageAction(plugin_id='phylogeny',
                    action_id='align_to_tree_mafft_fasttree'),
    use.UsageInputs(sequences=rep_seqs),
    use.UsageOutputNames(alignment='mafft-fasttree-alignment',
                         masked_alignment='mafft-fasttree-masked-alignment',
                         tree='mafft-fasttree-tree',
                         rooted_tree='mafft-fasttree-rooted-tree'))
:::

(infer-phylogenies-fragment-insertion)=
## Fragment insertion

QIIME 2 offers several ways to construct a phylogenetic tree.
Here, we're going to create a fragment insertion tree using the [`q2-fragment-insertion`](#q2-plugin-fragment-insertion) plugin.
The authors of the fragment insertion plugin suggest that it can outperform traditional alignment based methods based on short Illumina reads by alignment against a reference tree built out of larger sequences.
Our command, [`qiime fragment-insertion sepp`](#q2-action-fragment-insertion-sepp) will use the representative sequences (a `FeatureData[Sequence]` [artifact](xref:rachis-glossary-target#term-artifact)) we used above to create a phylogenetic tree where the sequences have been inserted into the greengenes 13_8 99% identity reference tree backbone.

First, we will download the reference database:

:::{describe-usage}

sepp_refs = use.init_artifact_from_url(
    'sepp-refs-gg-13-8',
    'https://data.qiime2.org/classifiers/sepp-ref-dbs/sepp-refs-gg-13-8.qza')
:::

:::{note}
This command is resource intensive - if your computation environment supports it, we suggest including an appropriately-set `--p-threads` parameter.
:::

:::{describe-usage}

sepp_tree, sepp_placements = use.action(
    use.UsageAction(plugin_id='fragment_insertion',
                    action_id='sepp'),
    use.UsageInputs(representative_sequences=rep_seqs,
                    reference_database=sepp_refs,
                    threads=1),
    use.UsageOutputNames(tree='sepp-tree',
                         placements='sepp-placements'))
:::

**Congratulations! You now know how to construct a phylogeny in QIIME 2!**
