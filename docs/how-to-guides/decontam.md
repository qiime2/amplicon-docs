(decontam-howto)=
# How to use decontam to remove microbiome contamination

[Decontam](https://doi.org/10.1186/s40168-018-0605-2) is a bioinformatics decontamination tool applicable to both amplicon and metagenomic sequencing data, that leverages the differing relative abundances of contaminants in control samples when compared to experimental samples as well as those samples with low biomass when compared to samples with high biomass.
Contaminants within microbial measurements are a consistent and pervasive issue within the field.
These contaminants have the capacity to impact taxonomic assignments, relative abundance calculations, and even promote the archiving of spurious taxa which can lead to incorrect assumptions and interpretations.
This is of particular in low-biomass environments where the impact of these contaminants is heightened due to the low amount of starting biological material from the target community.
Decontam seeks to remedy this by removing contaminants at the feature level before relative abundance calculation and has been shown to be effective in identifying contaminants in datasets of various structures.
Here we show how to use Decontam through the `q2-quality-control` plugin.

```{note}
This tool was developed and maintained by [Benjamin Callahan](https://github.com/benjjneb/decontam) and this guide was originally written by [Jorden Rabasco](https://github.com/jordenrabasco).
If you use decontam through `q2-quality-control` in your work, please cite the [original paper](https://doi.org/10.1186/s40168-018-0605-2).
```

## QIIME 2 Basics

If you're completely new to QIIME 2, we recommend reading [Getting Started with QIIME 2](https://amplicon-docs.qiime2.org/en/latest/explanations/getting-started.html) to familiarize yourself with concepts that may be helpful.
To install QIIME 2 or MOSHPIT, both of which will include the `q2-quality-control` decontam functionality by default, follow the instructions [here](https://library.qiime2.org/quickstart).

## Installation and base actions

The `q2-quality-control` decontam functionality consists of two main actions: [`decontam-identify`](q2-action-quality-control-decontam-identify) and [`decontam-score-viz`](q2-action-quality-control-decontam-score-viz).

The `decontam-identify` action produces an artifact containing the decontam scores for each feature in the dataset.
This artifact is then passed into the `decontam-score-viz` visualizer to display the distribution of decontam scores and help determine where the threshold should be set to eliminate the majority of contaminants while retaining non-contaminant features.
To then remove contaminants based on this threshold, actions in the `q2-feature-table` plugin can be used.

## Tutorial and Walkthrough

### Step 0: Access the tutorial data

This tutorial's example commands reference the following example data.
To download the example table, representative_sequences, and metadata follow the below steps.

:::{describe-usage}
:scope: decontam-howto

table = use.init_artifact_from_url(
    'table',
    'https://github.com/jordenrabasco/q2-decontam-tutorial/raw/main/data_objs/table.qza'
)
:::

:::{describe-usage}
rep_seqs = use.init_artifact_from_url(
    'rep_seqs',
    'https://github.com/jordenrabasco/q2-decontam-tutorial/raw/main/data_objs/rep_seqs.qza'
)
:::

:::{describe-usage}
sample_metadata = use.init_metadata_from_url(
    'sample-metadata',
    'https://github.com/jordenrabasco/q2-decontam-tutorial/raw/main/data_objs/metadata.tsv'
)
:::

### Step 1: Identify suspected contaminants

The first step is to run `decontam-identify`.
This action runs the functionality of the base decontam application.
You will need to decide which method of decontamination to use: frequency, prevalence, or combined.
An in-depth explanation of the functionality of each method can be found [here](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html).
Each decontam method requires unique metadata to run appropriately.
The frequency method requires that each sample processed has corresponding concentration information.
This information allows identification of contaminants through the simple idea that contaminants will be in greater relative abundance in low concentration samples than in high DNA concentration samples.
The prevalence method requires control samples to be included in the dataset being analyzed.
These control samples need to be identified via a metadata column that differentiates them from experimental samples.
This method works on the premise that contaminants will be in higher relative abundances in control samples than in experimental samples.
The combined method as the name suggests utilizes facets of both aforementioned methods and combines them to form a composite decontam score.
Just as each method has it's own unique metadata, each method also has its own unique parameters.
Parameters that are unique to the frequency method have the prefix `freq` and parameters that are unique to the prevalence method have the prefix `prev`.
The combined method uses all prevalence and frequency parameters.

**Arguments/Parameters**:

- `table`: A `FeatureTable[Frequency]` artifact such as an ASV or OTU table.
- `metadata-file`: A metadata file corresponding to the data being analyzed(needs to be tab delimited).
- `method`: The decontamination method that will be used.
- `freq-concentration-column`: The metadata column that holds the concentration information of each sample.
- `prev-control-column`: The column in the metadata file that encodes whether a sample is experimental or control.
- `prev-control-indicator`: Text within the `prev-control-column` that identifies control samples.

:::{note}
`frequency`, `prevalence`, and `combined` are alternative methods.
Only one is needed to identify contaminants in your samples.
:::

#### Option 1: `frequency` Method
To run `decontam-identify` with the frequency method perform the following.
**The frequency method is the only decontamination method that can be used when there are no control samples.**

:::{describe-usage}
prev_decontam_scores, = use.action(
    use.UsageAction(plugin_id='quality_control', action_id='decontam_identify'),
    use.UsageInputs(
        table=table,
        metadata=sample_metadata,
        method='frequency',
        freq_concentration_column='Concentration',
    ),
    use.UsageOutputNames(
        decontam_scores='freq_decontam_scores'
    )
)
:::

#### Option 2: `prevalence` Method
To run `decontam-identify` with the prevalence method perform the following.

:::{describe-usage}
prev_decontam_scores, = use.action(
    use.UsageAction(plugin_id='quality_control', action_id='decontam_identify'),
    use.UsageInputs(
        table=table,
        metadata=sample_metadata,
        method='prevalence',
        prev_control_column='Sample_or_Control',
        prev_control_indicator='control'
    ),
    use.UsageOutputNames(
        decontam_scores='prev_decontam_scores'
    )
)
:::

#### Option 3: `combined` Method
To run `decontam-identify` with the combined method perform the following.

:::{describe-usage}
comb_decontam_scores, = use.action(
    use.UsageAction(plugin_id='quality_control', action_id='decontam_identify'),
    use.UsageInputs(
        table=table,
        metadata=sample_metadata,
        method='combined',
        freq_concentration_column='Concentration',
        prev_control_column='Sample_or_Control',
        prev_control_indicator='control'
    ),
    use.UsageOutputNames(
        decontam_scores='comb_decontam_scores'
    )
)
:::

### Step 2: Visualize suspected contaminants

The second step in the `q2-quality-control` decontam workflow is `decontam-score-viz`.
This step allows for visualization of the decontam scores in the form of a histogram and a table that includes the following information for each feature:
- feature ID
- the determination of whether the sequence is a contaminant or not (based on the given threshold)
- the decontam score output from the Decontam algorithm
- the corresponding read number for each feature (abundance)
- the number of samples in which the feature appears (prevalence)
- the associated DNA sequence

This action was designed to assist in investigating contaminants and identifying which threshold to use when removing contaminants.
To select an appropriate threshold for the data, the contaminant feature distribution within the histogram of decontam scores will need to be identified.
Decontam score distributions are typically bimodal, meaning that there are two peaks within the distribution.
The peaks correspond to a sub-distribution of contaminant features and a sub-distribution of true features.
A feature with a lower decontam score indicates more evidence that the feature is a contaminant.
A feature with a higher decontam indicates less evidence that the feature is a contaminant.
Below is the histogram from the `decontam-score-viz` action using the example data provided in this tutorial.

::: {style="text-align:center"}
<img src="https://github.com/jordenrabasco/q2-decontam-tutorial/raw/main/data_objs/assets/example_hist.png" alt="hist" width="500"/>
:::

The left side of the histogram (0-0.1 or 0.15) has a partial normal distribution ending at 0.1 or 0.15 with a small amplitude, which is indicative of a typical contaminant feature distribution within the overall decontam score histogram if the associated dataset has a low amount of contaminates.
If a dataset has a larger amount of contaminants the partial normal distribution encompassing the lower decontam scores will increase in amplitude.
There are buttons in the visualization that allow those features identified as non-contaminant or contaminant features to be downloaded as individual fasta files for asynchronous investigation.

::: {style="text-align:center"}
<img src="https://github.com/jordenrabasco/q2-decontam-tutorial/raw/main/data_objs/assets/fasta_buttons.png" alt="buttons" width="1200"/>
:::

To investigate specific features within the experiment the following table is provided in the visualization.
It is located below the histogram and the fasta download buttons:

::: {style="text-align:center"}
<img src="https://github.com/jordenrabasco/q2-decontam-tutorial/raw/main/data_objs/assets/example_table.png" alt="table"/>
:::

**Arguments/Parameters**:

- `decontam-scores`: This is a collection of decontam scores that are output individually by the `decontam-identify` action and is defined as a `Collection[FeatureData[DecontamScore]]`. Collections are used in this and the following parameter to allow multiple subsets of data to be visualized side-by-side.
- `table`: A collection of ASV or OTU table, of type `Collection[FeatureTable[Frequency]]`.
- `i-rep-seqs`: `A FeatureData[Sequence]` artifact, representing the sequences of the features in the feature table.
- `threshold`: This is the threshold at and below which features are designated as contaminants.
- `weighted`: Whether to weight the histogram in the visualization by the read abundance. Not weighting will produce a histogram with features instead of reads in each decontam score bin.
- `bin-size`: The proportional bin size of the histogram. It is recommend that the bin size be 0.05 for best visualization of the decontam score bimodal distribution.

To run `decontam-score-viz` perform the following.

:::{describe-usage}
decontam_scores_collection = use.construct_artifact_collection(
    'decontam_scores_collection', {'first': comb_decontam_scores}
)
table_collection = use.construct_artifact_collection(
    'tables_collection', {'first': table}
)

use.action(
    use.UsageAction(
        plugin_id='quality_control', action_id='decontam_score_viz'
    ),
    use.UsageInputs(
        decontam_scores=decontam_scores_collection,
        table=table_collection,
        rep_seqs=rep_seqs,
        threshold=0.1,
        weighted=False,
        bin_size=0.05
    ),
    use.UsageOutputNames(visualization='decontam_score_viz')
)
:::

### Step 3: Remove suspected contaminants

To remove the contaminant features actions in the `q2-feature-table` plugin can be used.
Below, SQLite syntax is used in the `where` parameter to filter features.
The steps remove features and corresponding sequences whose decontam scores fall below the 0.1 threshold.
This allows accurate and contaminant-free downstream analysis.
More information about the `q2-feature-table` plugin is available here [here](https://library.qiime2.org/plugins/qiime2/q2-feature-table/overview).

:::{describe-usage}
comb_decontam_scores_md = use.view_as_metadata(
    'comb_decontam_scores_md', comb_decontam_scores
)

filtered_table, = use.action(
    use.UsageAction(
        plugin_id='feature_table', action_id='filter_features'
    ),
    use.UsageInputs(
        table=table,
        metadata=comb_decontam_scores_md,
        where='[p]>0.1 OR [p] IS NULL',
    ),
    use.UsageOutputNames(filtered_table='filtered_table')
)
:::

:::{describe-usage}
filtered_table, = use.action(
    use.UsageAction(
        plugin_id='feature_table', action_id='filter_seqs'
    ),
    use.UsageInputs(
        data=rep_seqs,
        table=filtered_table,
    ),
    use.UsageOutputNames(filtered_data='filtered_rep_seqs')
)
:::
