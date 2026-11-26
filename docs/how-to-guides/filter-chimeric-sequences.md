(filter-chimeric-sequences)=
# How to identify and filter chimeric feature sequences with `q2-vsearch`

Chimera checking in [QIIME 2](https://qiime2.org) is performed on a pair of `FeatureTable[Frequency]` and `FeatureData[Sequence]` [artifacts](xref:rachis-glossary-target#term-artifact).
QIIME 2 wraps the Uchime *de novo* and reference pipelines from vsearch.
For details on how these work, see the original [Uchime paper](https://doi.org/10.1093/bioinformatics/btr381), and the [vsearch](https://github.com/torognes/vsearch) documentation.

In this guide, we'll use a feature table and sequences from the Atacama soils data set.

## Obtain the data

Download the necessary files:

:::{describe-usage}
:scope: filter-chimeric-sequences

atacama_table = use.init_artifact_from_url(
    'atacama-table',
    'https://data.qiime2.org/2025.4/tutorials/chimera/atacama-table.qza')
:::

:::{describe-usage}

atacama_rep_seqs = use.init_artifact_from_url(
    'atacama-rep-seqs',
    'https://data.qiime2.org/2025.4/tutorials/chimera/atacama-rep-seqs.qza')
:::

## Run *de novo* chimera checking

:::{describe-usage}

chimeras, nonchimeras, stats = use.action(
    use.UsageAction(plugin_id='vsearch',
                    action_id='uchime_denovo'),
    use.UsageInputs(table=atacama_table,
                    sequences=atacama_rep_seqs),
    use.UsageOutputNames(chimeras='chimeras',
                         nonchimeras='nonchimeras',
                         stats='stats'))
:::

:::{note}
Reference-based chimera checking is also available - see [`vsearch uchime-ref`](#q2-action-vsearch-uchime-ref) for more details.
:::

## Visualize summary stats

To learn more about the sequences that were identified as chimeric, we can `tabulate` the stats output from the previous step:

:::{describe-usage}

stats_as_md = use.view_as_metadata('stats_as_md', stats)

use.action(
    use.UsageAction(plugin_id='metadata',
                    action_id='tabulate'),
    use.UsageInputs(input=stats_as_md),
    use.UsageOutputNames(visualization='stats-summary'))
:::

## Filter input tables and sequences

### Exclude chimeras and "borderline chimeras"

:::{describe-usage}

nonchimeras_as_md = use.view_as_metadata('nonchimeras_as_md', nonchimeras)

table_nonchimeric_wo_borderline, = use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='filter_features'),
    use.UsageInputs(table=atacama_table,
                    metadata=nonchimeras_as_md),
    use.UsageOutputNames(filtered_table='table-nonchimeric-wo-borderline'))

rep_seqs_nonchimeric_wo_borderline, = use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='filter_seqs'),
    use.UsageInputs(data=atacama_rep_seqs,
                    metadata=nonchimeras_as_md),
    use.UsageOutputNames(filtered_data='rep-seqs-nonchimeric-wo-borderline'))

use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='summarize'),
    use.UsageInputs(table=table_nonchimeric_wo_borderline),
    use.UsageOutputNames(summary='table-nonchimeric-wo-borderline-summary',
                         sample_frequencies='sample-frequencies-nonchimeric-wo-borderline',
                         feature_frequencies='feature-frequencies-nonchimeric-wo-borderline'))
:::

### Exclude chimeras but retain "borderline chimeras"

:::{describe-usage}

chimeras_as_md = use.view_as_metadata('chimeras_as_md', chimeras)

table_nonchimeric_w_borderline, = use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='filter_features'),
    use.UsageInputs(table=atacama_table,
                    metadata=chimeras_as_md,
                    exclude_ids=True),
    use.UsageOutputNames(filtered_table='table-nonchimeric-w-borderline'))

rep_seqs_nonchimeric_w_borderline, = use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='filter_seqs'),
    use.UsageInputs(data=atacama_rep_seqs,
                    metadata=chimeras_as_md,
                    exclude_ids=True),
    use.UsageOutputNames(filtered_data='rep-seqs-nonchimeric-w-borderline'))

use.action(
    use.UsageAction(plugin_id='feature_table',
                    action_id='summarize'),
    use.UsageInputs(table=table_nonchimeric_w_borderline),
    use.UsageOutputNames(summary='table-nonchimeric-w-borderline-summary',
                         sample_frequencies='sample-frequencies-nonchimeric-w-borderline',
                         feature_frequencies='feature-frequencies-nonchimeric-w-borderline'))
:::
