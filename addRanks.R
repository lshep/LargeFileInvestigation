pkg_tbl = read.csv("packagelist.csv")

library(BiocPkgTools)
library(dplyr)
library(tidyr)

pkg_tbl$pkgType <- recode(pkg_tbl$Repo,
                          "bioc" = "software",
                          "data-experiment" = "data-experiment",
                          "workflows" = "workflows",
                          "annotation" = "data-annotation")  # Add more if needed

results <- mapply(
  function(pkg, type) pkgDownloadRank(pkg = pkg, pkgType = type),
  pkg_tbl$Package,
  pkg_tbl$pkgType,
  SIMPLIFY = FALSE
)

download_ranks <- sapply(results, function(x) names(x)[1])
percentile <- sapply(results, function(x) as.character(x[[1]]))  # "42.66"
pkg_tbl$DownloadRank <- download_ranks
pkg_tbl$Percentile <- percentile


get_package_yearly_stats <- function(repo, package) {
  url <- sprintf("https://bioconductor.org/packages/stats/%s/%s/%s_stats.tab",
                 repo, package, package)
  
  stats <- tryCatch({
    read.delim(url, stringsAsFactors = FALSE)
  }, error = function(e) {
    warning(sprintf("Could not read data for %s", package))
    return(NULL)
  })
  
  if (!is.null(stats)) {
    stats <- subset(stats, Month == "all")
    stats <- stats[order(-stats$Year), ]
    return(stats[, c("Year", "Nb_of_distinct_IPs")])
  }
  
  return(NULL)
}

# ---- Get stats for all packages ----
stats_list <- mapply(
  function(repo, pkg) get_package_yearly_stats(repo, pkg),
  pkg_tbl$Repo,
  pkg_tbl$Package,
  SIMPLIFY = FALSE
)

names(stats_list) <- pkg_tbl$Package

# ---- Convert each stats table to wide format ----
stats_wide_list <- lapply(stats_list, function(df) {
  if (is.null(df)) return(NULL)
  wide <- setNames(as.list(df$Nb_of_distinct_IPs), df$Year)
  return(wide)
})

# ---- Combine into single data frame ----
# All years across all packages
all_years <- sort(unique(unlist(lapply(stats_wide_list, names))), decreasing = TRUE)

# Convert the named list into a data frame
stats_long_df <- bind_rows(lapply(names(stats_wide_list), function(pkg) {
  data.frame(
    Package = pkg,
    Year = as.integer(names(stats_wide_list[[pkg]])),
    Nb_of_distinct_IPs = as.integer(stats_wide_list[[pkg]])
  )
}))

# Pivot to wide format
stats_wide_df <- stats_long_df %>%
  pivot_wider(names_from = Year, values_from = Nb_of_distinct_IPs, values_fill =
                                                                       NA)


final_tbl <- pkg_tbl %>%
  left_join(stats_wide_df, by = "Package")

save.image(file="investigation.Rdata")

write.csv(file="packages_filled_stats.csv", final_tbl)
