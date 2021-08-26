library(shiny)
ui <- fluidPage(
  titlePanel("Genes ranked by MI between voxel-level gene transcription levels and treatment effect for group"),
  fluidRow(column(4, selectInput("group","Treatment Group:",c("BACE1 young","LCP old")))),
  DT::dataTableOutput("table")
)
server <- function(input, output) {
  output$table <- DT::renderDataTable(DT::datatable({
    if (input$group == "BACE1 young") {
      data <- read.csv("BACE1_young_size-mean_p0.05_genes_mi.csv")
    } else {
      data <- read.csv("LCP_old_size-mean_p0.05_genes_mi.csv")
    }
    colnames(data) <- c("Gene", "MI")
    data
  }))
}
shinyApp(ui = ui, server = server)
