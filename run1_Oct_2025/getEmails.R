emailList1 = c(
"AssessORFData",
"brgedata",
"chipenrich.data",
"macrophage",
"mammaPrintData",
"MetaGxPancreas",
"mtbls2",
"oct4",
"pRolocdata",
"rcellminerData",
"RNAseqData.HNRNPC.bam.chr14",
"systemPipeRdata",
"topdownrdata",
"tximportData",
"WES.1KG.WUGSC",
"seqpac",
"BioTIP",
"GenomicPlot",
"SPOTlight",
"Statial",
"dreamlet",
"epistasisGA",
"erma",
"markeR",
"microbiome",
"msqrob2",
"musicatk",
"netZooR",
"proActiv",
"scRepertoire",
"singleCellTK"
)

library(httr2)
library(dplyr)
library(jsonlite)

url_base = "http://127.0.0.1:4567/info/package/"
all_emails <- c()
for (pkg in emailList1) {
  endpoint_url <- paste0(url_base, pkg)

  try({
      response <- request(endpoint_url) %>% req_perform()
      json_txt <- resp_body_string(response)
      json_data <- fromJSON(json_txt)
      
      if (!is.null(json_data$email)) {
          all_emails <- c(all_emails, json_data$email)
      } else if ("email" %in% names(json_data[[1]])) {
          emails <- sapply(json_data, function(x) x$email)
          all_emails <- c(all_emails, emails)
      }
      
  }, silent = TRUE)
}

all_emails <- unique(all_emails)

write(paste(all_emails, collapse = ", "), file = "email_list_V1.txt")
#writeLines(all_emails, "email_list.txt")

emailList2 = c(
"Affyhgu133aExpr",
"Affyhgu133Plus2Expr",
"Affymoe4302Expr",
"ccdata",
"ChAMPdata",
"ChIPXpressData",
"ConnectivityMap",
"curatedBreastData",
"davidTiling",
"Fletcher2013b",
"FlowSorted.Blood.450k",
"FlowSorted.CordBlood.450k",
"FlowSorted.CordBloodNorway.450k",
"FlowSorted.DLPFC.450k",
"furrowSeg",
"GeuvadisTranscriptExpr",
"hapmapsnp6",
"HD2013SGI",
"Hiiragi2013",
"ListerEtAlBSseq",
"MMDiffBamSubset",
"msdata",
"msPurityData",
"pd.atdschip.tiling",
"RnBeads.hg38",
"rRDPData",
"Single.mTEC.Transcriptomes",
"SVM2CRMdata",
"blimaTestingData",
"RGMQLlib",
"methylationArrayAnalysis",
"SwathXtend"    
)


library(httr2)
library(dplyr)
library(jsonlite)

url_base = "http://127.0.0.1:4567/info/package/"
all_emails2 <- c()
for (pkg in emailList2) {
  endpoint_url <- paste0(url_base, pkg)

  try({
      response <- request(endpoint_url) %>% req_perform()
      json_txt <- resp_body_string(response)
      json_data <- fromJSON(json_txt)
      
      if (!is.null(json_data$email)) {
          all_emails2 <- c(all_emails2, json_data$email)
      } else if ("email" %in% names(json_data[[1]])) {
          emails <- sapply(json_data, function(x) x$email)
          all_emails2 <- c(all_emails2, emails)
      }
      
  }, silent = TRUE)
}

all_emails2 <- unique(all_emails2)

write(paste(all_emails2, collapse = ", "), file = "email_list_V2.txt")

    
