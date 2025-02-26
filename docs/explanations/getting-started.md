(getting-started)=
# Getting started with QIIME 2

This chapter will briefly introduce a few concepts that should help you learn QIIME 2 quickly.

## What is QIIME 2?

To date, most people think of QIIME 2 as a microbiome marker gene (i.e., amplicon) analysis tool.
That is where the project started, and what its predecessor [QIIME 1](https://doi.org/10.1038/nmeth.f.303) was.
QIIME 2 began as a complete rewrite of QIIME 1, where we were attempting to address common feature requests from our users and reduce challenges that we saw our users encountering.
This resulted in our developing unique functionality including our [data provenance tracking system](getting-started:provenance), a [decentralized plugin-based ecosystem of tools](getting-started:plugins), and the ability to use those through [interfaces](getting-started:interfaces) designed to support users with different computational backgrounds ([](#multiple-interfaces)).
Much of this functionality is not unique to microbiome marker gene analysis, but rather general to biological data science, and as result the scope of QIIME 2 is now broader than when we started.
So, what is QIIME 2?

What most people think of as "QIIME 2" is what we refer to in our documentation as the *amplicon distribution of QIIME 2*, or simply the *amplicon distribution*.
This is the microbiome marker gene analysis toolkit.
**This documentation site is for the *amplicon distribution* specifically.**

The *amplicon distribution* is built on what we call the QIIME 2 Framework (or *the framework*).
The framework is where the general-purpose functionality exists, including data provenance tracking, the plugin manager, and more.
As an end user, you don't really need to know anything about this, but it's helpful to know that it exists and is different from the amplicon distribution to understand the ecosystem of tools.
The amplicon distribution, and other tools such as [MOSHPIT](https://moshpit.readthedocs.io/) (formerly referred to as the *metagenome distribution*) and [genome-sampler](https://genome-sampler.readthedocs.io/), are technically *built on top of the QIIME 2 Framework*.

**The amplicon distribution of QIIME 2 includes a suite of plugins that provide broad analytic functionality that supports microbiome marker gene analysis from raw sequencing data through publication quality visualizations and statistics.**
There is not a single QIIME 2 workflow or command - rather it is a series of steps, and you choose which ones to apply.
We provide general guidance through tutorials, like the [](moving-pictures-tutorial), and can provide more specific guidance on the [QIIME 2 Forum](https://forum.qiime2.org).
Any amplicon is supported - not just the 16S rRNA gene.
The plugins that come with the amplicon distribution are listed in [](available-plugins).
Other plugins can also be installed independently - your main source for discovery and installation instructions for these is the [QIIME 2 Library](https://library.qiime2.org)[^developing-plugins].

## Important concepts

The following sections briefly present some important concepts for understanding QIIME 2 tools.
You don't need to fully understand these to start using QIIME 2, but we think it will help you learn and build your bioinformatics skills if you have some brief exposure to these ideas.
Links to where you can learn more are provided[^power-user].

(getting-started:interfaces)=
### Interfaces

All of QIIME 2's analytic functionality can be accessed through multiple different interfaces, and you can choose to work with the one (or more) of these that you think you'll be most efficient with ([](#multiple-interfaces)).
For example, domain scientists without advanced computing backgrounds can using QIIME 2 through graphical interfaces such as Galaxy.
Power users can work with QIIME 2 on the command line, enabling straight-forward access on high-performance compute clusters and cloud resources.
Research software engineers and data scientists can use QIIME 2 through its Python 3 API, facilitating development of automated workflows and integration of QIIME 2 tools as a component in other systems.
The ability to use the same analysis tools through different interfaces is a big part of what makes QIIME 2 **accessible**.

```{figure} ../_static/multiple-interfaces.png
:label: multiple-interfaces
:alt: Screenshots of different types of interfaces that can be used to interact with QIIME 2.
:align: center

Examples of four QIIME 2 interfaces: QIIME 2 View, Galaxy, q2cli, and the Python 3 API.
```

You're also free to use different interfaces for different steps - QIIME 2 won't care.
For example, a fairly common workflow is to use the command line (q2cli) for long-running jobs on a high-performance computing system, and then download the results and work with them in a Jupyter Notebook using the Python 3 API for the more exploratory iterative steps of an analysis.

#### Different interface options in tutorials

When you're working with QIIME 2 tutorials, we'll generally provide instructions that enable you to work in different interfaces[^tutorial-interfaces].
This will look like the following, and you can choose to follow the instructions for the interface that you're currently working with.

:::{describe-usage}
:scope: getting-started

sample_metadata = use.init_metadata_from_url(
   'sample-metadata',
   'https://data.qiime2.org/2025.4/tutorials/moving-pictures/sample_metadata.tsv')

sample_metadata_viz, = use.action(
  use.UsageAction(plugin_id='metadata',
                  action_id='tabulate'),
  use.UsageInputs(input=sample_metadata),
  use.UsageOutputNames(visualization='sample_metadata_viz')
)
:::

:::{aside}
Notice that after the command block presented here, there is a link to download or view the result of running that command.
This enables you to see the output of a QIIME 2 command without running it yourself, so is convenient for exploring the types of outputs that QIIME 2 can create.
:::

(getting-started:artifacts-and-visualizations)=
### Artifacts and visualizations

One of the first things that new QIIME 2 users often notice is the `.qza` and `.qzv` files that QIIME 2 uses.
All files generated by QIIME 2 are either `.qza` or `.qzv` files, and **these are simply `zip` files that store your data alongside some QIIME 2-specific metadata**.
Here is what you need to know about these:

- `.qza` files store QIIME 2 Artifacts on disk.
  QIIME 2 Artifacts represent data that are generated by QIIME 2 and intended to be used by QIIME 2, such as intermediary files in an analysis workflow.
  `qza` stands for *QIIME Zipped Artifact*.
- `.qzv` files store QIIME 2 Visualizations on disk.
  QIIME 2 Visualizations represent data that are generated by QIIME 2 and intended to be viewed by humans, such as an interactive visualization.
  `qzv` stands for *QIIME Zipped Visualization*.
- `.qza` and `.qzv` files can be loaded with [QIIME 2 View](https://view.qiime2.org)[^view-options].
- Because `.qza` and `.qzv` files are simple `zip` files, you can open them with any *unzip* utility, such as WinZip, 7Zip, or `unzip`.
  You don't need to have QIIME 2 installed to access the information in these files.
  For an example of how to get data out of these files using `unzip`, see [](explanations-archives).

:::{tip} Confused by the term "artifact"?
:class: dropdown
The term "artifact" has multiple different meanings, so our usage is sometimes confusing for new QIIME 2 users.
In the context discussed here, "artifact" means *an object made or shaped by some agent or intelligence*.
This is common usage in data science and software engineering.
In biology, it is also used to mean *a finding or structure in an experiment or investigation that is not a true feature of the object under observation, but is a result of external action, the test arrangement, or an experimental error.*

The definitions quoted here were obtained [from Wiktionary](https://en.wiktionary.org/wiki/artifact) (accessed 26 Feb 2025), and are used in accordance with the [CC BY-SA 4.0 license](https://creativecommons.org/licenses/by-sa/4.0/).
:::

(getting-started:provenance)=
### Data provenance

QIIME 2 was designed to automatically document analysis workflows for users, ensuring that their bioinforamtics work is **reproducible**.
This allows you, or consumers of your research, to discover exactly how any QIIME 2 result (i.e., Artifact or Visualization) was produced.

To achieve this, each QIIME 2 command is recorded when it is run, and that information is stored in all Artifacts and Visualizations that are created[^provenance-in-artifacts].
This means that unless you remove files from a `.qza` or `.qzv` file, your result's data provenance is always stored alongside the data.
Whenever you or someone else needs that information, it's there.

In addition to supporting reproducible bioinformatics, data provenance helps others provide you with technical support.
If you're running into an error or an odd result and request help, someone may ask you to share an Artifact or Visualization so they can view your data provenance.
This will let them review in exact detail what you did to generate the result, and we've found that this makes the process of providing technical support much more efficient.

You can view your data provenance using [QIIME 2 View](https://view.qiime2.org) (click the *Provenance* tab after loading your file), or by [using Provenance Replay](https://forum.qiime2.org/t/provenance-replay-beta-release-and-tutorial/23279).

:::{warning}
QIIME 2 goes to great lengths to ensure that your bioinformatics workflow will be reproducible.
This includes recording information about your analysis inside of your Results' data provenance, and the recorded information includes metadata that you provided to run specific commands.
For this and other reasons, we strongly recommend that you **never include confidential information, such as Personally Identifying Information (PII), in your QIIME 2 metadata**.
**Because QIIME 2 stores metadata in your data provenance, confidential information that you use in a QIIME 2 analysis will persist in downstream Results.**

Instead of including confidential information in your metadata, you should encode it with variables that only authorized individuals have access to.
For example, subject names should be replaced with anonymized subject identifiers before use with QIIME 2.
:::

(getting-started:plugins)=
### Plugins and actions

There is no microbiome-specific functionality (or even bioinformatics-specific functionality) in the QIIME 2 Framework.
Rather all of the analysis functionality comes in the form of *plugins* to the framework.

Plugins define actions, which are the individual commands that you'll run in an analysis workflow.
For example, the `q2-feature-table` plugin, which is included in the amplicon distribution, defines the actions listed [here](../references/plugin-reference/plugins/feature-table/index).
If you did't have the `q2-feature-table` plugin installed, you wouldn't have access to those actions.

Another thing to know about plugins is that anyone can create and distribute them.
This is what makes QIIME 2 **extensible**.
For example, if a student develops new analysis functionality that they want to use with QIIME 2, they can create their own QIIME 2 plugin[^developing-plugins].
If they want others to be able to use it, they can distribute that plugin on the [QIIME 2 Library](https://library.qiime2.org), or through any other means that they choose.

(getting-started:artifact-classes)=
### Artifact classes

All QIIME 2 artifacts are assigned exactly one *artifact class*, which indicates the semantics of the data (its *semantic type*) and the file format that is used to store it inside of the `.qza` file.
When you see artifacts (or inputs or outputs to an action) described with terms that look like `Phyogeny[Rooted]` or `Phylogeny[Unrooted]`, that is the Artifact Class.

Artifact classes were developed to help users avoid misusing actions, and to help them discover new methods.
For example, if an action should only be applied to a rooted phylogenetic tree, the developer of that action should annotate its input as `Phylogeny[Rooted]`.
This will ensure that if a user mistakenly tries to provide an unrooted phylogenetic tree, QIIME 2 can error to help the user avoid making a mistake that might waste time or create a misleading result.
If another action can take a rooted or an unrooted phylogenetic tree, that input would be annotated as `Phylogeny[Rooted | Unrooted]`.

In graphical QIIME 2 interfaces, it's possible to view the available actions based on what Artifact Class(es) they accept as input.
This can allow a user to query the system with questions like "What actions are available to apply to a rooted phylogenetic tree?", or "What actions are available to create a rooted phylogenetic tree from an unrooted phylogenetic tree?".

If you'd like to learn more about Artifact Classes, see [*Semantic types, data types, file formats, and artifact classes*](https://develop.qiime2.org/en/latest/plugins/explanations/types-of-types.html) in *Developing with QIIME 2*.

## Next steps

Ok, that's enough discussion about QIIME 2 for now: it's time to start using it.
Don't worry if you feel like you don't fully understand some of the details that were covered in this chapter right now.
The goal of this chapter was to introduce these ideas, and they'll be revisited throughout the documentation.

### Deploying QIIME 2

You may now be wondering where and how you'll deploy QIIME 2.
QIIME 2 can be deployed on your personal computer (e.g., your laptop or desktop computer), a cluster computer such as one owned and maintained by your university or company, or on cloud computing resources.
In [](how-to-deploy) these options for deploying QIIME 2 are described, and relevant references to the installation instructions are referenced.
I recommend having a working deployment of QIIME 2 when you're ready to start working through tutorials, so you can follow along on your own.

### Learning with the tutorials

After you have a working deployment of QIIME 2, you can read and work through the [](moving-pictures-tutorial).
This is the resource that most new users start with to learn.
In this tutorial, you'll carry out a full microbiome analysis, from raw sequence data through visualizations and statistics.
This is a fairly typical amplicon analysis workflow, so after you understand it you can adapt it for your own analysis.

If you'd like to get more of a feel for what QIIME 2 can do before you invest in installing it, we also recommend the [](moving-pictures-tutorial).
That document has all of the results pre-generated and linked from the document, so as you read you can interact with the results that would be generated by each step.

### Getting help

The [QIIME 2 Forum](https://forum.qiime2.org) is where you can get free technical support and connect with other microbiome researchers.
We look forward to seeing you there!

[^tutorial-interfaces]: Transitioning all of our tutorials to provide instructions for different interfaces is a work in progress (as of 26 February 2025).
 In the meantime, some may include only command line instructions.

[^developing-plugins]: If you become interested in building and distributing your own QIIME 2 plugins, for marker gene or any other type of analysis, you can refer to our developer manual, [Developing with QIIME 2](https://develop.qiime2.org).

[^power-user]: When you're ready to learn more about how the QIIME 2 Framework works, and how you can leverage it to become a QIIME 2 power user, you can refer to our book on that topic, [Using QIIME 2](https://use.qiime2.org).
  Using QIIME 2 provides information that is relevant across all QIIME 2 distributions and plugins, not just the amplicon distribution.

[^view-options]: Other options for viewing `.qza` and `.qzv` files are discussed [here](https://use.qiime2.org/en/latest/how-to-guides/view-visualizations.html).

[^provenance-in-artifacts]: Data provenance is some of the metadata that is stored alongside your data in `.qza` and `.qzv` files.
  Retaining provenance information without a centralized database is one of the reasons why QIIME 2 produces `.qza` and `.qzv` files, as opposed to just outputting data on its own (e.g., in `.fasta` or `.biom` files).