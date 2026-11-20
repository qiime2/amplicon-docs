# qiime2/amplicon-docs

Source for the [QIIME 2 amplicon documentation](https://amplicon-docs.readthedocs.io).

`404.html` is the site's not-found page, including the notice for links into the retired Sphinx docs (`/2024.10/...` and earlier releases, and `/jupyterbooks/...`).
It is self-contained (inline CSS, JavaScript and logo) because Read the Docs serves it at whatever URL was requested; `make html` copies it to the top of the build output.
Read the Docs takes it from the default version (`stable`), so changes to it go live when the `stable` tag moves.
The page also recognizes an old-docs path under a `/<language>/<version>/` prefix, because the project's "HTML to clean URL" redirect sends a missing `/<page>.html` (such as a page of the old Jupyter Book tutorial) to `/en/stable/<page>/`; for `/jupyterbooks/...` it turns the trailing `/` back into `.html`.
To try it on a pull request's preview build, put the old-docs path after the preview's `/en/<PR number>/` prefix (e.g. `/en/<PR number>/2024.10/tutorials/moving-pictures/`).