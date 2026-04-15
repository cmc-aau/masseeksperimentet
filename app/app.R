library("leaflet")
library("shiny")

ui <- fluidPage(
  titlePanel("Masseeksperimentet"),
  leafletOutput("map", height = "90vh")
)

server <- function(input, output, session) {
  MXmetadata <- read.csv("MXmetadata.csv")
  
  # Render the initial map
  output$map <- renderLeaflet({
    leaflet(MXmetadata) %>%
      addTiles() %>%
      addAwesomeMarkers(
        lng = ~PointLongitude, lat = ~PointLatitude, 
        layerId = ~LibID,
        icon = awesomeIcons(
          library = 'ion'
          #,markerColor = 
        )
      )
  })
  
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    LibID <- click$id
    
    # Show a modal with the pregenerated heatmap PNG
    showModal(modalDialog(
      title = paste("Sample:", LibID),
      # Shinylive looks in 'www' for 'src'
      img(src = file.path(paste0(LibID, ".png")), width = "100%"),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
}

shinyApp(ui, server)
