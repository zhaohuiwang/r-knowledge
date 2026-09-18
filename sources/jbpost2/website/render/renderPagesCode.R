#Code to render each webpage

#grab names from the Rmd folder
to_render <- list.files("Rmd")
#pull off just the name without the .Rmd
pages <- unlist(strsplit(to_render, split = ".Rmd"))

#now render all the pages. Need a separate case for the README due to the menu level differences
lapply(pages, FUN = function(x){
  if(x == "README"){
    rmarkdown::render(paste0("Rmd/", x, ".Rmd"), 
                    output_format = "github_document", 
                    output_file = paste0("../", x, ".md"), 
                    output_options = list(html_preview = FALSE)
  )} else {
    rmarkdown::render(paste0("Rmd/", x, ".Rmd"), 
                      output_format = "github_document", 
                      output_file = paste0("../pages/", x, ".md"), 
                      output_options = list(html_preview = FALSE)
    )}
})
