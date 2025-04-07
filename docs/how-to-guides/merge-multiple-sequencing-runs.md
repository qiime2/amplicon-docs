(merge-runs)=
# How to merge data from multiple sequencing runs

This document illustrates how to integrate data for a single study that was generated on more than one sequencing run.
Our general recommendation is that this be done at the feature table stage, rather than prior to quality control.
With some quality control methods (notably DADA2) this is required, while with others it's optional.

:::{warning} Too advanced?
If you don't already have some experience with running QIIME 2, this document might be too technical of a place to start out.
[](#getting-started) and then [](#gut-to-soil-tutorial) are better starting points.
:::

The data used in this guide were sequenced on two Illumina MiSeq sequencing runs, and were originally published in [](https://doi.org/10.48550/arXiv.2411.04148).
The data used here are subsampled to 10% of the original input sequences so the commands can be run quickly.
You can find the full dataset in [the study's Artifact Repository](https://doi.org/10.5281/zenodo.13887456).

## Overview of the process

At a high level, this process works as follows if merging data from two or more sequencing runs:
1. Demultiplex each sequencing run, resulting in one "demux artifact" (e.g., `SampleData[PairedEndSequencesWithQuality]`) per sequencing run.
1. Perform quality control on each "demux artifact" resulting in one `FeatureTable` and `FeatureData[Sequence]` per sequencing run.
1. Merge all per-run `FeatureTable` artifacts into a single `FeatureTable` artifact.
1. Merge all `FeatureData[Sequence]` artifacts into a single `FeatureData[Sequence]` artifact.
1. Merge metadata, if necessary.

## Obtain sample metadata and two "demux artifacts"

The following commands will download the sample metadata as tab-separated text, and two demultiplexed sequence artifacts representing two different sequencing runs.
Note that in this example, all sample metadata from the full study is contained in a single sample metadata file.
If that were not the case, you can merge your sample metadata (see [How to merge metadata](https://use.qiime2.org/en/latest/how-to-guides/merge-metadata.html)).

:::{tip}
It's always a good idea to include a column in your metadata indicating which sequencing run a sample was on.
When doing downstream analysis, it then becomes straight-forward to look for sequencing run effects (e.g., by coloring points by sequencing run in an ordination plot).
:::

:::{describe-usage}
:scope: merge-runs

sample_metadata = use.init_metadata_from_url(
   'sample-metadata',
   'https://www.dropbox.com/scl/fi/irosimbb1aud1aa7frzxf/sample-metadata.tsv?rlkey=f45jpxzajjz9xx9vpvfnf1zjx&st=nahafuvy&dl=1')
:::

:::{describe-usage}

demux_nano1 = use.init_artifact_from_url(
   'demux_nano1',
   'https://www.dropbox.com/scl/fi/hpsl1hxa0kj3njhes7p64/demux-10p.qza?rlkey=e5brlu9xn4qcrqaan11z2oi7d&st=r9or2kur&dl=1')
:::

:::{describe-usage}

demux_nano2 = use.init_artifact_from_url(
   'demux_nano2',
   'https://www.dropbox.com/scl/fi/73f6rmcq7lelug5qbuhl6/demux-10p.qza?rlkey=s0hoh326fes3z2usvgs62tv3c&st=peakjay3&dl=1')
:::

## Sequence quality control

We'll begin by performing quality control on the demultiplexed sequence artifacts independently, by calling [DADA2](https://doi.org/10.1038/nmeth.3869)'s `denoise-paired` command on each set of demultiplexed sequences.
The trim and truncation parameters should be chosen based on your data.
You should use the same parameters for each run.

:::{describe-usage}

asv_seqs_nano1, asv_table_nano1, stats_nano1 = use.action(
    use.UsageAction(plugin_id='dada2',
                    action_id='denoise_paired'),
    use.UsageInputs(demultiplexed_seqs=demux_nano1,
                    trim_left_f=0,
                    trunc_len_f=250,
                    trim_left_r=0,
                    trunc_len_r=250),
    use.UsageOutputNames(representative_sequences='asv_seqs_nano1',
                         table='asv_table_nano1',
                         denoising_stats='stats_nano1'))

asv_seqs_nano2, asv_table_nano2, stats_nano2 = use.action(
    use.UsageAction(plugin_id='dada2',
                    action_id='denoise_paired'),
    use.UsageInputs(demultiplexed_seqs=demux_nano2,
                    trim_left_f=0,
                    trunc_len_f=250,
                    trim_left_r=0,
                    trunc_len_r=250),
    use.UsageOutputNames(representative_sequences='asv_seqs_nano2',
                         table='asv_table_nano2',
                         denoising_stats='stats_nano2'))
:::

## Merging data

After quality control is complete, you'll have two `FeatureTable` artifacts and two `FeatureData[Sequence]` artifacts.
Merging at this stage simplifies downstream work.
You can do this using the following two commands.

(merge-feature-tables)=
### Merging `FeatureTable` artifacts

:::{describe-usage}
asv_table, = use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='merge'),
    use.UsageInputs(tables=[asv_table_nano1, asv_table_nano2]),
    use.UsageOutputNames(merged_table='asv_table'))
:::

(merge-feature-data-sequences)=
### Merging `FeatureData[Sequence]` artifacts

:::{describe-usage}
asv_seqs, = use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='merge_seqs'),
    use.UsageInputs(data=[asv_seqs_nano1, asv_seqs_nano2]),
    use.UsageOutputNames(merged_data='asv_seqs'))
:::

## Downstream analysis

At this stage, you can continue on as if you had generated your data on a single sequencing run.
For example, you can generate a summary of the merged feature table as follows.

:::{describe-usage}
use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='summarize_plus'),
    use.UsageInputs(table=asv_table,
                    metadata=sample_metadata),
    use.UsageOutputNames(summary='asv_table',
                         sample_frequencies='sample_frequencies',
                         feature_frequencies='asv_frequencies'))
:::