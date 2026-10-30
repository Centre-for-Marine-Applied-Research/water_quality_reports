# Updated with Claude Opus 5.5

# Knit a plot in its own chunk, so each figure made in a loop can have its own
# size. Based on http://michaeljw.com/blog/post/subchunkify/
#
# g:          plot object (e.g., from ss_plot_variables())
# label:      unique chunk label, e.g., the figure number. Figure files are
#             named after the label, so it must be unique in the document.
# fig_height: figure height (inches)
# fig_width:  figure width (inches)
# dpi:        figure resolution

subchunkify <- function(g, label, fig_height = 7, fig_width = 5, dpi = 72) {
  sub_chunk <- paste0(
    "```{r subchunk-", label,
    ", fig.height=", fig_height,
    ", fig.width=", fig_width,
    ", dpi=", dpi,
    "}\n",
    "g\n",
    "```\n"
  )

  cat(knitr::knit_child(text = sub_chunk, envir = environment(), quiet = TRUE))
}
