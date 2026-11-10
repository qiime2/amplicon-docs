# qiime2/amplicon-docs

Source for the [QIIME 2 amplicon documentation](https://amplicon-docs.readthedocs.io).

`404.html` is the site's not-found page, including the notice for links into the retired Sphinx docs (`/2024.10/...` and earlier).
It is self-contained (inline CSS, JavaScript and logo) because Read the Docs serves it at whatever URL was requested; `make html` copies it to the top of the build output.
Read the Docs takes it from the default version (`stable`), so changes to it go live when the `stable` tag moves.
To try it on a pull request's preview build, put the old-docs path after the preview's `/en/<PR number>/` prefix (e.g. `/en/36/2024.10/tutorials/moving-pictures/`); the page drops that prefix on `*.readthedocs.build` hosts.