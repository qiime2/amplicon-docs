(how-to-deploy)=
# How to deploy QIIME 2
QIIME 2 can be used on different types of systems, and each has its own benefits and drawbacks.
This document discusses those, and provides references for how to use each.

QIIME 2 can be installed natively on macOS or Linux personal computers, and on Windows personal computers that support the Windows Subsystem for Linux.
QIIME 2 can also be used through Docker or Podman.

```{embed} #install-pointer
```

## Using QIIME 2 on your personal computer
Using QIIME 2 on your personal computer is a very convenient option, but may be impractical for some steps of your analysis workflow.
Steps that run quickly - usually things like filtering, data visualization, and statistical analysis - often work great on personal computers.
Steps such as sequence quality control and taxonomic assignment however may require more CPU or memory resources than are available on your personal computer.
This might make those steps impossible to run, or might render your personal computer useless for other tasks while you're waiting for a run to complete.
That could take days or even weeks, depending on how powerful your personal computer is and how big the data set is that you're working with.

A related option is that you could have a dedicated computer for running QIIME 2 analyses.
This could be a server that your team owns and maintains, and that everyone on your team has access to.
Then, if you need to let a job run for a long time, that machine can run for days or weeks without disrupting other work that you need to do on your personal computer.
If you go with this option, it's best to think about having that computer connected to a backup power supply in case of a power outage days into an analysis.

## Using QIIME 2 on a cluster computer
If you have access to a cluster computer, this is a great option for running QIIME 2.
A cluster will typically have the resources needed to run QIIME 2 on large data sets.
Typically you can reach out to your institution's high performance computing or research computing office, and let them know that you need to use QIIME 2.
They will have a process for having it installed on the system and made available for you to use.

One downside of using QIIME 2 on a cluster is that often you'll only have command line (i.e., terminal) access to the cluster - not a graphical interface.
This means that to view QIIME 2 results you'll need to move them off that computer to your local machine for viewing.
This isn't a problem - just a minor inconvenience that you'll need to get used to.

## Using QIIME 2 on cloud hardware
If you do not have access to a cluster computer, there are many cloud computing service providers that you can use to run QIIME 2.
With these types of services, you rent computer resources at an hourly rate.
This is very similar to running on a cluster computer, except that someone else owns and maintains the hardware (rather than you or your institution owning and maintaining it).
If you expect to run QIIME 2 analyses fairly infrequently (e.g., monthly or less) this can be a very cost effective option.

## Using QIIME 2 on Galaxy

Several different public [Galaxy](https://galaxyproject.org/) servers provide access to QIIME 2.
This can be a very convenient way to use QIIME 2 through a graphical interface, and if you have worked with Galaxy in the past there will likely be little new that you need to learn to use this option.
The server we're most familar with is [cancer.usegalaxy.org](https://cancer.usegalaxy.org), but you can find the most up-to-date information on the [Galaxy website](https://galaxyproject.org/).

## Combinations of the above approaches

I ([`@gregcaporaso`](https://forum.qiime2.org/u/gregcaporaso)) personally find it convenient to use both a cluster computer and my personal computer for running QIIME 2.
My university has a cluster computer that all researchers at the university have access to, and our high performance computing team keeps an up-to-date version of QIIME 2 installed on that computer.
I typically run the long-running steps of my workflows on the cluster and then download the results to my personal computer.
Then, when I'm at a more iterative stage of my analysis (for example, when generating visualizations and running statistical tests), I'll run those commands locally so I can easily view the results.
Most personal computers are powerful enough for these steps.
