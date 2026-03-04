# Microbiome marker gene analysis with QIIME 2

Welcome! 👋
This is the primary documentation introducing the use of QIIME 2 for marker gene (i.e., amplicon) based microbiome analysis.

:::{note} Transition from "the old docs"
As of April 2025, this site replaces the old QIIME 2 user documentation, `https://docs.qiime2.org`.
We've prioritized content to transition from the old documentation based on our website analytics, so the most frequently accessed content is already here.
If you're looking for content from the old QIIME 2 user documentation, you can find it at https://docs.qiime2.org/2024.10/ (but please consider [letting us know](https://github.com/qiime2/amplicon-docs/issues) what that content is, as we're trying to transition everything that's needed to this site).
:::

Based on our website analytics, these are the questions that most frequently drive readers to our documentation:

:::{dropdown} I'm completely new to QIIME 2. Where should I start?
:open:
We recommend that all newcomers read [](#getting-started) for a high-level discussion about what QIIME 2 is, an introduction to concepts that will help you understand QIIME 2 quickly, and references to resources you can use for learning.
:::

:::{dropdown} How can I analyze my data with QIIME 2?
Historically, the [](#moving-pictures-tutorial) is the resource that most users have started with to learn how to use QIIME 2.
More recently, we've developed the [](#gut-to-soil-tutorial).
Both are written for readers who are also new to microbiome analysis.
If you're already familiar with microbiome analysis but new to QIIME 2, we recommend also looking at [](#experienced-researchers) and [](#conceptual-overview).
:::

:::{dropdown} How do I install QIIME 2?
![](#install-pointer)
:::

:::{dropdown} Where can I find reference materials or other resources?
If you're looking for reference material on the plugins and actions installed in the QIIME 2 amplicon distribution, see [](#available-plugins).
If you're looking for data resources, such as pre-trained taxonomic classifiers, see [*Data Resources* on the QIIME 2 Library](https://library.qiime2.org/data-resources) website.
If you're looking for other tools available for the QIIME 2 Framework (Q2F), see [*Plugins* on the QIIME 2 Library](https://library.qiime2.org/plugins).
:::

:::{dropdown} How should I prepare my metadata?
See our documentation of the [Metadata file format](https://use.qiime2.org/en/latest/references/metadata.html).
:::

:::{dropdown} Where can I find help?
Head over to the [QIIME 2 Forum](https://forum.qiime2.org), where you can browse nearly 10 years of discussion, questions, and answers related to microbiome data science with QIIME 2.
You can ask your own questions if you don't find existing answers, and give back by answering someone else's questions when you're ready.
:::

:::{dropdown} Where can I find announcements and other news?
Important announcements (e.g., new releases, bug reports, upcoming changes) are shared through the [Announcements](https://forum.qiime2.org/c/announcements/8) feed on the QIIME 2 Forum.
If you register for a (free) account, you can get those announcements by email.
Alternatively, you can [subscribe by RSS](https://qiime2.org/rss.xml).
:::

For other topics, read on...

## Navigating this documentation

This documentation is organized under the [Diátaxis](https://diataxis.fr/) framework for technical documentation, which categorizes content into *sections* containing *Tutorials*, *How-To-Guides*, *Explanations*, and *References*.
Each serves a different goal for the reader:

:::{list-table}
:header-rows: 1

* - Chapter
  - Purpose

* - Tutorials
  - Provide a guided exploration of a topic for **learning**.

* - How To Guides
  - Provide step-by-step instructions on how to **accomplish specific goals**.

* - Explanations
  - Provide a discussion intended to aid in **understanding** a specific topic.

* - References
  - Provide specific **information** (e.g., the list of [available plugins](#available-plugins)).
:::

(contributors)=
## Contributors

This documentation is the result of past, present, and future (🤞) collaborative efforts.

The authors would like to thank [those who have contributed](https://github.com/qiime2/docs/graphs/contributors) to the writing of the original QIIME 2 User Documentation, as well as [those who have contributed to this documentation](https://github.com/qiime2/amplicon-docs/graphs/contributors).
Some of the content in this documentation is sourced directly from the older material.

The QIIME 2 Forum [moderators](https://forum.qiime2.org/g/q2-mods) and [community members](https://forum.qiime2.org/u?order=likes_received&period=all) have also been instrumental to the development of ideas and content presented here.

## Funding 🙏

This work was funded in part by NIH National Cancer Institute Informatics Technology for Cancer Research grant [1U24CA248454-01](https://reporter.nih.gov/project-details/9951750).

This documentation is built with MyST Markdown and Jupyter Book, which are supported in part with [funding](https://sloan.org/grant-detail/6620) from the Alfred P. Sloan Foundation.

Initial support for the development of QIIME 2 was provided through a [grant](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1565100) from the National Science Foundation.

## Citing QIIME 2

If you use QIIME 2 in your work, please cite [Bolyen, Rideout, Dillon, Bokulich, et al (2019)](https://doi.org/10.1038/s41587-019-0209-9), as well as the underlying tools that are used by QIIME 2.
To get a list of citations that are specifically relevant to a QIIME 2 Result you created (i.e., a `.qza` or `.qzv`), load that Result with [QIIME 2 View](https://view.qiime2.org) and navigate to the *Citations* tab.

## License

*Microbiome Marker Gene Analysis with QIIME 2* (©2025) and the project's predecessors have many @contributors.
Content development and maintenance is led by the [Caporaso Lab](https://caplab.bio) at [Northern Arizona University](https://nau.edu).
This content is licensed under CC BY-NC-ND 4.0
