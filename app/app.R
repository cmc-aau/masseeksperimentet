library("leaflet")
library("shiny")

ui <- fluidPage(
  titlePanel("Masseeksperimentet"),
  leafletOutput("map", height = "90vh")
)

server <- function(input, output, session) {
  MXmetadata <- read.csv("metadata.csv")

  output$map <- renderLeaflet({
    leaflet(MXmetadata) %>%
      addTiles() %>%
      addAwesomeMarkers(
        lng = ~PointLongitude, lat = ~PointLatitude,
        layerId = ~LibID,
        icon = awesomeIcons(library = "ion", markerColor = "blue")
      )
  })

  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    selected_id <- click$id

    sample_info <- MXmetadata[MXmetadata$LibID == selected_id, ]

    showModal(modalDialog(
      title = paste("Prøve ID:", selected_id, "-", MXmetadata[MXmetadata$LibID == selected_id, "SampleID"]),
      # load images directly from GitHub instead of bundling them into the app JSON file because of the 100MB file limit on GitHub
      img(src = paste0("https://raw.githubusercontent.com/cmc-aau/masseeksperimentet/refs/heads/main/plots/", selected_id, ".png"), width = "100%"),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
}

shinyApp(ui, server)
