#Code to render each blogpost

rmarkdown::render("RmdBlog/Post1.Rmd", 
                  output_format = "github_document", 
                  output_file = "../pages/Post1.md", 
                  output_options = list(html_preview = FALSE)
)

rmarkdown::render("RmdBlog/Post2.Rmd", 
                  output_format = "github_document", 
                  output_file = "../pages/Post2.md", 
                  output_options = list(html_preview = FALSE)
)
