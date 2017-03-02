# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

fluidPage(
  titlePanel("Basic DataTable"),

  # Create a new row for the table.
  fluidRow(
    DT::dataTableOutput("table")
  )
)