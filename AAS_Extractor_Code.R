{
  
  library(magrittr)
  library(rAltmetric)
  library(purrr)
  
  apikey_aux <- readline("API key:") 
  
  #The following code is the ropensci property "rAltmetric"
  
  
  #rAltmetric - ropensci: https://github.com/ropensci/rAltmetric
  # https://ropensci.org/tags/altmetrics/
  # Karthik Ram (2017). rAltmetric: Retrieves altmerics data for any published paper from altmetrics.com. R package version 0.7. http://CRAN.R-project.org/package=rAltmetric
  
  
  
  
  altmetrics <-
    function(oid = NULL,
             id = NULL,
             doi = NULL,
             pmid = NULL,
             arxiv = NULL,
             isbn = NULL,
             uri = NULL,
             apikey = getOption('altmetricKey'),
             foptions = list(),
             ...) {
      if (is.null(apikey))
        apikey <- apikey_aux
      
      acceptable_identifiers <- c("doi", "arxiv", "id", "pmid", "isbn", "uri")
      # If you start hitting rate limits, email support@altmetric.com
      # to get your own key.
      
      
      if (all(sapply(list(oid, doi, pmid, arxiv, isbn, uri), is.null)))
        stop("No valid identfier found. See ?altmetrics for more help", call. =
               FALSE)
      
      # If any of the identifiers are not prefixed by that text:
      if (!is.null(id)) id <- prefix_fix(id, "id")
      if (!is.null(doi)) doi <- prefix_fix(doi, "doi")
      if (!is.null(isbn)) isbn <- prefix_fix(isbn, "isbn")
      if (!is.null(uri)) uri <- prefix_fix(uri, "uri")
      if (!is.null(arxiv)) arxiv <- prefix_fix(arxiv, "arXiv")
      if (!is.null(pmid)) pmid <- prefix_fix(pmid, "pmid")
      
      # remove the identifiers that weren't specified
      identifiers <- ee_compact(list(oid, id, doi, pmid, arxiv, isbn, uri))
      
      
      # If user specifies more than one at once, then throw an error
      # Users should use lapply(object_list, altmetrics)
      # to process multiple objects.
      if (length(identifiers) > 1)
        stop(
          "Function can only take one object at a time. Use lapply with a list to process multiple objects",
          call. = FALSE
        )
      
      if (!is.null(identifiers)) {
        ids <- identifiers[[1]]
      }
      
      
      supplied_id <-
        as.character(as.list((strsplit(ids, '/'))[[1]])[[1]])
      
      # message(sprintf("%s", supplied_id))
      if (!(supplied_id %in% acceptable_identifiers))
        stop("Unknown identifier. Please use doi, pmid, isbn, uri, arxiv or id (for altmetric id).",
             call. = F)
      base_url <- "http://api.altmetric.com/v1/"
      args <- list(key = apikey)
      request <-
        httr::GET(paste0(base_url, ids), query = args, foptions, httr::add_headers("user-agent" = "#rstats rAltmertic package https://github.com/ropensci/rAltmetric"))
      if(httr::status_code(request) == 404) {
        stop("No metrics found for object")
      } else {
        httr::warn_for_status(request)
        results <-
          jsonlite::fromJSON(httr::content(request, as = "text"), flatten = TRUE)
        results <- rlist::list.flatten(results)
        class(results) <- "altmetric"
        results
        
      }
    }
  
  altmetric_data <- function(alt_obj) {
    if (inherits(alt_obj, "altmetric"))  {
      res <- data.frame(t(unlist(alt_obj)), stringsAsFactors = FALSE)
    }
    res
  }
  
  #' @noRd
  ee_compact <- function(l)
    Filter(Negate(is.null), l)
  
  #' @noRd
  prefix_fix <- function(x = NULL, type = "doi") {
    if(is.null(x))
      stop("Some identifier required")
    
    # Check for arXiv and arxiv
    type2 <- tolower(type)
    val <- c(grep(type, x), grep(type2, x))
    
    if(any(val == 1)) {
      # lose the prefix and grab the ID
      id <-  strsplit(x, ":")[[1]][2]
      res <- paste0(tolower(type),"/", id)
    } else {
      res <- paste0(tolower(type),"/", x)
    }
    res
  }
  
  alm <- function (x) altmetrics(doi = x) %>% altmetric_data()
  
  
  #The following code is the new part (By: Rafael Castanha: https://github.com/rafaelcastanha)
  #https://github.com/rafaelcastanha/Altmetric-Attention-Score-Extractor
  
  
  almerror<-possibly(alm, otherwise = '0')
  
  corpus<-read.table(file.choose(), header = FALSE)
  corpus<-as.list(corpus, header = FALSE)
  x<-corpus$V1
  
  y<-x
  
  for (i in 1:length(x)){
    x[i]<-almerror(x[i])['score']
  }
  
  aas<-t(data.frame(x))
  colnames(aas)<-"Altmetric Attention Score"
  aas<-data.frame(aas)
  rownames(aas)<-y
  aas<- tibble::rownames_to_column(aas, "DOI")
  aas[is.na(aas)]<-0
  
  write.table(aas, file="Score List.txt", row.names = FALSE, sep="\t", dec=",", col.names = TRUE) #Save The AAS List
  
}