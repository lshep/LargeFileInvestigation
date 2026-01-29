## Add reverse dependencies to see affect of removal
library(BiocPkgTools)

tbl <- read.csv("PackageMaintainers_LargeFiles.csv")

pkgs <- tbl$package
RevDeps <- character(length(pkgs))
recursiveRevDeps <- character(length(pkgs))
RevDeps_count <- integer(length(pkgs))
recursiveRevDeps_count <- integer(length(pkgs))


for(p in 1:length(pkgs)){

    deps <- pkgBiocRevDeps(pkgs[p], only.bioc=FALSE, recursive=FALSE)
    deps_vec <- unique(unlist(deps, use.names = FALSE))
    RevDeps_count[p] <- length(deps_vec)
    RevDeps[p] <- paste(deps_vec, collapse = " ")

    deps <- pkgBiocRevDeps(pkgs[p], only.bioc=FALSE, recursive=TRUE)
    deps_vec <- unique(unlist(deps, use.names = FALSE))
    recursiveRevDeps_count[p] <- length(deps_vec)
    recursiveRevDeps[p] <- paste(deps_vec, collapse = " ")
}


tbl$RevDeps_count <- RevDeps_count
tbl$RecursiveRevDeps_count <- recursiveRevDeps_count
tbl$RevDeps <- RevDeps
tbl$RecursiveRevDeps <- recursiveRevDeps

write.csv(tbl, "PackageMaintainers_LargeFiles_WithRevDeps.csv", row.names =
  FALSE, quote = TRUE)
