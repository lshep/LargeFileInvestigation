library(httr2)
library(dplyr)
library(jsonlite)

url_base = "https://pkgmaintainers.bioconductor.org/info/package/"

## function to extract maintainer info
## Had chatgpt alter original look up
extract_maintainers <- function(file_name) {
  pkglist <- read.delim(file_name, header = FALSE)[,1]
  
  pkg_maintainers <- list()
  
  for (pkg in pkglist) {
    endpoint_url <- paste0(url_base, pkg)
    
    maintainer_df <- data.frame(
      package = pkg,
      name = NA,
      email = NA,
      email_status = NA,
      notes = NA,
      stringsAsFactors = FALSE
    )
    
    try({
      response <- request(endpoint_url) %>% req_perform()
      json_txt <- resp_body_string(response)
      json_data <- fromJSON(json_txt)
      
      if (!is.null(json_data$email)) {
        # Single maintainer
        maintainer_df <- data.frame(
          package = pkg,
          name = json_data$name,
          email = json_data$email,
          email_status = ifelse(!is.null(json_data$email_status),
                                json_data$email_status, NA),
          notes = NA,
          stringsAsFactors = FALSE
        )
      } else if (length(json_data) > 0 && "email" %in% names(json_data[[1]])) {
        # Multiple maintainers
        maintainer_df <- data.frame(
          package = pkg,
          name = sapply(json_data, function(x) x$name),
          email = sapply(json_data, function(x) x$email),
          email_status = sapply(json_data, function(x)
            ifelse(!is.null(x$email_status), x$email_status, NA)),
          notes = NA,
          stringsAsFactors = FALSE
        )
      }
    }, silent = TRUE)
    
    pkg_maintainers[[pkg]] <- maintainer_df
  }
  
  # Combine all into a single dataframe
  bind_rows(pkg_maintainers)
}


## Just Git Blobs
df_gitblobs <- extract_maintainers("AllPackagesWithGitBlobs.txt")
write.csv(df_gitblobs, "PackageMaintainers_GitBlobs.csv", row.names = FALSE)

## Just Active Large Files
df_largefiles <- extract_maintainers("AllPackagesWithActiveLargeFiles.txt")
write.csv(df_largefiles, "PackageMaintainers_LargeFiles.csv", row.names = FALSE)
