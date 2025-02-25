# Microbiome marker gene analysis with QIIME 2

Welcome! 👋

This is the primary documentation introducing the use of QIIME 2 for marker gene (i.e., amplicon) based microbiome analysis.
This site replaces the old QIIME 2 user documentation, `https://docs.qiime2.org`.
If you're looking for content from the old QIIME 2 user documentation, you can find it at https://docs.qiime2.org/2024.10/ (but do [let us know](https://github.com/qiime2/amplicon-docs/issues) what that content is, as we're trying to transition everything that's needed to this site).

## Navigating this documentation

Based on our website analytics, these are the topics users are most frequently looking for in our documentation:

- **New to QIIME 2?**
  We recommend that you read [](explanations/getting-started) for a high-level discussion about what QIIME 2 is and the resources that are available to you for learning.

- **Learning, or just exploring?**
  The [](tutorials/moving-pictures) is the resource that most users start with to learn how to use QIIME 2.
  It's written for readers who are also new to microbiome analysis.
  If you want to try or learn QIIME 2, we recommend starting with the [](tutorials/moving-pictures).
  All of the outputs generated during the tutorial are linked in the tutorial document, so you can also read through it and interact with the results without running any of the commands on your own.
  If you're already familiar with microbiome analysis but new to QIIME 2, we recommend also looking at [](explanations/experienced-researchers) and [](explanations/some-theory).

- **Ready to install QIIME 2?**
  See [](how-to-guides/install).

- **Need information on specific tools?**
  If you're looking for reference material on the plugins and actions installed in the QIIME 2 amplicon distribution, see [](references/available-plugins).
  If you're looking for data resources, such as pre-trained taxonomic classifiers, see our [Data Resources](https://resources.qiime2.org) website.
  If you're looking for other tools available for the QIIME 2 Framework (🌳), see the [QIIME 2 Library](https://library.qiime2.org).

- **Need help with your metadata?**
  See our documentation of the [Metadata file format](https://use.qiime2.org/en/latest/references/metadata.html).

- **Need to import or export data?**
  See [](how-to-guides/import-export).

- **Need technical support?**
  Head over to the [QIIME 2 Forum](https://forum.qiime2.org), where you can browse nearly 10 years of discussion, questions, and answers related to microbiome data science with QIIME 2.
  You can ask your own questions if you don't find existing answers, and give back by answering someone else's questions when you're ready.
  "The Forum" is also where we make important [Announcements](https://forum.qiime2.org/c/announcements/8) - if you register for a (free) account, you can get those announcements by email.
  For the most up-to-date information on how to get help with QIIME 2, as a user or developer, see [here](https://github.com/qiime2/.github/blob/main/SUPPORT.md).

For other topics, read on...

## How this documentation is organized

This documentation is organized under the [Diátaxis](https://diataxis.fr/) framework {cite}`diataxis` for technical documentation, which categorizes content into *sections* containing *Tutorials*, *How-To-Guides*, *Explanations*, and *References*.
Each serves a different goal for the reader:

:::{list-table}
:header-rows: 1

* - Chapter
  - Purpose

* - [Tutorials](tutorials/intro)
  - Provide a guided exploration of a topic for **learning**.

* - [How To Guides](how-to-guides/intro)
  - Provide step-by-step instructions on how to **accomplish specific goals**.

* - [Explanations](explanations/intro)
  - Provide a discussion intended to aid in **understanding** a specific topic.

* - [References](references/intro)
  - Provide specific **information** (e.g., the list of [available plugins](available-plugins)).
:::

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
To get the list of relevant citations, load a QIIME 2 Result (i.e., a `.qza` or `.qzv`) file with [QIIME 2 View](https://view.qiime2.org) and navigate to the *Citations* tab.

## License

*Microbiome Marker Gene Analysis with QIIME 2* (©2025) and the project's predecessors have many @Contributors.
Content development and maintenance is led by the [Caporaso Lab](https://cap-lab.bio) at [Northern Arizona University](https://nau.edu).
This content is licensed under CC BY-NC-ND 4.0
