library(shiny)
library(png)

ui <- fluidPage(
  titlePanel(strong("Local predictors of anti-Amyloid-Beta therapy efficacy revealed by quantitative whole-brain microscopy")),
  fluidRow(column(4, selectInput("group","Treatment Group:",c("NB360 (5-month-old)","LIN5044 (14-month-old)")))),
  h3("Voxel-level changes in mean Amyloid-Beta plaque size:"),
  p("Thresholded at p < 0.05 (", span("decrease", style = "color:magenta"), ",",
    span("increase", style = "color:green"),")"),
  imageOutput("image", width = "700", height = "470"),
  h3("Genes ranked by mutual information (MI) between gene transcription levels and treatment effect:"),
  DT::dataTableOutput("table")
)
server <- function(input, output, session) {
  
  output$image <- renderImage({
    
    if (input$group == "NB360 (5-month-old)") {
      image.filename <- "BACE1_young_sm_p0.10_FDR_mip.png"
    } else {
      image.filename <- "LCP_old_sm_p0.10_FDR_mip.png"
    }
    image.filename <- normalizePath(file.path("./data", image.filename))
    
    width  <- session$clientData$output_image_width
    height <- session$clientData$output_image_height
    pixelratio <- session$clientData$pixelratio
    outfile <- tempfile(fileext='.png')
    png(outfile, width = width*pixelratio, height = height*pixelratio, res = 72*pixelratio)
    pp <- readPNG(image.filename)
    plot.new()
    rasterImage(pp, 0, 0, 1, 1)
    dev.off()
    list(src = outfile, width = width, height = height)
  }, deleteFile = TRUE)
  
  output$table <- DT::renderDataTable(DT::datatable({
    if (input$group == "NB360 (5-month-old)") {
      data <- read.csv("data/BACE1_young_size-mean_p0.05_genes_mi.csv")
    } else {
      data <- read.csv("data/LCP_old_size-mean_p0.05_genes_mi.csv")
    }
    colnames(data) <- c("Gene", "MI")
    data
  }))
}
shinyApp(ui = ui, server = server)
