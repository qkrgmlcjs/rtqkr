# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- gs_ls()

    data
  }))
  
}