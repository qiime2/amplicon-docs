
(how-to-export)=
# How to export data for use outside of QIIME 2

Sometimes you'll want use QIIME 2 data with something other than QIIME 2.
If that tool doesn't support working with QIIME 2 Artifacts, you will need to export your data.
This document will teach you how to export data from QIIME 2 artifacts.

:::{warning}
When exporting data from a QIIME 2 artifact, there will no longer be provenance associated with the data.
We describing this as breaking the provenance chain, or *breaking provenance*.
From that point on, you're responsible for maintaining your own data processing records.
It's therefore best to only export data from artifacts when you are done with all processing steps that can be achieved with QIIME 2, to maximize the value of each artifact's provenance.

If you import data that was exported from QIIME 2, the provenance associated with the imported artifact will begin with that import step since the exported data doesn't have provenance associated with it.
:::

:::{tip}
If you export data from QIIME 2, it's a good idea to record the UUID of the Artifact that the data was exported from.
This lets you link that original, unmodified exported data to QIIME 2 data provenance.
:::

(unzip-artifacts)=
## Exporting without QIIME 2 installed

If you have a QIIME 2 artifact or visualization, and don't have QIIME 2 installed, the easiest way to access the data is using an unzip utility.
Because `.qza` and `.qzv` files are just `.zip` files with a different extension, any unzip utility should work.
Popular options are `unzip`, WinZip, and 7zip.

When you unzip a `.qza` or `.qzv` file, the resulting top-level directory will be a string of letters and numbers representing the result's UUID.
We recommend that you record that information as it provides a link into QIIME 2 data provenance.
You'll find a `data` directory under the top-level directory.
All relevant data files are in that directory.
All files and directories outside of the `data` directory represent QIIME 2-specific metadata.

## Exporting using QIIME 2

### Python 3 API

If you're working with the Python 3 API, exporting generally isn't necessary.
When you `view` an Artifact, you'll have that object in a data structure that you can work with directly.
You can learn more about this in the [Python 3 API documentation](https://docs.qiime2.org/2024.10/interfaces/artifact-api/#interoperability-with-other-python-libraries).

### Command line interface

Exporting on the command line is performed using using `qiime tools export` command.
By default, you'll simply need to provide the path to the file that you want to export, and a **directory** (not a filename) that the data should be written to.
For example:

:::
qiime tools export \
  --input-path asv-table.qza \
  --output-path exported-table/
:::

::::{tip}
If you want data exported in a particular format that is supported by QIIME 2 for the Artifact Class that is being exported, you can specify that using the `--output-format` parameter.
The list of formats that can be used in exports can be reviewed using:

:::
qiime tools list-formats --exportable
:::

As of this writing (17 March 2025) these are under-documented, and we hope to compile better documentation of the available formats in the near future.
::::

## Extracting versus exporting

Extracting an artifact differs from exporting an artifact, and exporting is typically what users are looking for.
When exporting an artifact, only the data files will be placed in the output directory.
Extracting will additionally provide QIIME 2's metadata about an artifact, including for example the artifact's provenance, in the output directory in plain-text formats.
Extracting is effectively the same as unzipping an artifact, as described in [](#unzip-artifacts) -- it simply saves you from having to install an unzip utility if you already have QIIME 2 installed.

A QIIME 2 artifact in a file called `asv-table.qza` could be extracted as follows:

:::
qiime tools extract \
  --input-path asv-table.qza \
  --output-path extracted-table/
:::
