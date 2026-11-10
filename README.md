# Giuliano Mega's website

A Quarto website with Markdown and executable R Markdown posts. Published on
Netlify at <https://www.giulianomega.com/>.

## Local setup

Install [Quarto 1.11.9](https://quarto.org/docs/download/) and R (the lockfile was
tested with R 4.5.2), then restore the R packages from the repository root:

```sh
Rscript -e 'renv::restore()'
quarto preview
```

The backpropagation and generators posts also execute Python and Ruby. To rerun
them, install the optional environment using Conda:

```sh
conda env create -f environment.yml
conda activate personal-website
export RETICULATE_PYTHON="$CONDA_PREFIX/bin/python"
quarto render
```

Python/Ruby are not required for prose posts. Published computation results are
stored in `_freeze/`, so a full-site build can reuse results without executing
unchanged articles. A render targeting a single Rmd **does** execute its code.

## Write a post

Create a directory under `post/`, and copy either `templates/post.md` or
`templates/post.Rmd` into it as `index.md` or `index.Rmd`. Use one index source
per directory. `.qmd` is also supported.

```sh
mkdir -p post/my-new-post
cp templates/post.Rmd post/my-new-post/index.Rmd
quarto preview
```

Set the title, publication date, description, and categories. Templates start
with `draft: true`: drafts are visible in preview but excluded from publication.
Remove that setting when ready. Replace the template's example date with the
actual publication date.

For HackMD, export Markdown and save it as `post/my-new-post/index.md`. Add the
same metadata header. Download images into that directory and use relative
paths, such as `![Description](diagram.png)`, if you want to host them yourself.
Check any HackMD-specific embeds or extensions in the preview.

Rmd uses ordinary knitr chunks, for example:

````markdown
```{r fig-example, fig.cap="An example plot"}
plot(cars)
```

See @fig-example.
````

Shared citations live in `references.bib` and use `ieee.csl`. Existing articles
reference those files relative to their own directories. New posts can add
`bibliography: ../../references.bib` and `csl: ../../ieee.csl` to their metadata.

## Publish on Netlify

Before committing a computational post, render it locally:

```sh
quarto render post/my-new-post/index.Rmd
quarto render
```

Commit the post, its images, and updated `_freeze/` files. Do not commit `_site/`
or `.quarto/`. Plain Markdown posts can be built directly by Netlify.

`netlify.toml` replaces the old Hugo build command and publishes `_site/`.
`scripts/netlify-build.sh` downloads a pinned, checksum-verified Quarto release
and renders the site using frozen computations. This uses the existing Netlify
site and domain; no new hosting account is needed.

Review a Netlify Deploy Preview for the migration branch before merging into
the site's production branch. Netlify must already be connected to this Git
repository; account-level settings and deployment are managed in Netlify.

Existing article URLs are preserved as `/post/<original-filename>/`. `_redirects`
maps the old post index and post RSS feed to the homepage and new feed. The
homepage feed remains `/index.xml`.

## Maintenance

- Edit the introduction in `index.qmd` and appearance in `styles.scss`.
- `quarto render` refreshes changed computations (`freeze: auto`). Changes to
  external data or packages require explicitly rerendering the affected post.
- After changing R dependencies, run `renv::snapshot()` and commit `renv.lock`.
- Keep the Quarto version and checksum in `scripts/netlify-build.sh` in sync
  when upgrading. Preview math, diagrams, code, and citations after upgrades.
- Hugo/Academic sources have been removed; their history remains in Git.
