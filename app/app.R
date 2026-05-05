library("leaflet")
library("shiny")

ui <- fluidPage(
  titlePanel("Masseeksperimentet"),
  leafletOutput("map", height = "90vh"),
  tags$head(
    tags$style(HTML("
      /* This targets the ModalDialog container specifically when 'size = l' is used */
      .modal-dialog.modal-lg { 
        width: 90% !important; 
        max-width: 1000px !important; 
      }
      /* Optional: ensure the image doesn't get cut off vertically */
      .modal-body { 
        max-height: 80vh; 
        overflow-y: auto; 
      }
      .clickable-img:hover { 
        opacity: 0.8; 
        cursor: zoom-in; 
      }
    "))
  )
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
    
    showModal(
      modalDialog(
        title = paste("Prøve ID:", selected_id, "-", MXmetadata[MXmetadata$LibID == selected_id, "SampleID"]),
        # This CSS targets the dialog container itself
        tags$head(
          tags$style(HTML("
          @media (min-width: 992px) {
            .modal-lg { width: 100% !important; max-width: 1200px !important; }
          }
          .modal-body { overflow-y: auto; }
        "))
        ),
        # load images directly from GitHub instead of bundling them into the app JSON file because of the 100MB file limit on GitHub
        h2("Mest hyppige bakterier"),
        helpText("De 25 mest hyppige bakterier i jeres prøve (venstre) sammenlignet med udvalgte habitater i MicroFlora Danica projektet samt et gennemsnit for alle prøver i Masseeksperimentet (MX). Værdierne er i %."),
        tags$a(
          href = paste0("https://raw.githubusercontent.com/cmc-aau/masseeksperimentet/refs/heads/main/plots/", selected_id, "_heatmap.png"), 
          target = "_blank",
          img(
            src = paste0("https://raw.githubusercontent.com/cmc-aau/masseeksperimentet/refs/heads/main/plots/", selected_id, "_heatmap.png"),
            style = "width: 100%; height: auto; min-width: 800px;"
          )
        ),
        hr(),
        h2("Sammenligning med alle andre prøver"),
        helpText("Sammenligning af de mikrobielle samfund fundet i jeres prøve (rød) med de mikrobielle samfund i udvalgte habitater fra Microflora Danica. Ellipserne fra MicroFlora Danica repræsenterer den typiske mikrobielle sammensætning for et givet habitat. Jo tættere på centrum af ellipserne jeres prøve ligger, jo mere ligner det mikrobielle samfund i jeres prøve det, man finder i MicroFlora Danica habitaterne."),
        tags$a(
          href = paste0("https://raw.githubusercontent.com/cmc-aau/masseeksperimentet/refs/heads/main/plots/", selected_id, "_ordination.png"), 
          target = "_blank",
          img(
            src = paste0("https://raw.githubusercontent.com/cmc-aau/masseeksperimentet/refs/heads/main/plots/", selected_id, "_ordination.png"),
            style = "width: 100%; height: auto; min-width: 800px;"
          )
        ),
        easyClose = TRUE,
        footer = modalButton("Close"),
        size = "l"
      )
    )
  })
}

shinyApp(ui, server)
