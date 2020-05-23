library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Map viewer in Shiny"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput("ylat", label = h4("Lattitude"), value = 52.130, min = -90.0, max = 90.0),
            numericInput("xlon", label = h4("Longitude"), value = 21.100, min= -180.0, max = 180.0)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                id = "mainpanels",
                tabPanel("Map", leafletOutput("view_map", width = "100%", height = "800px"))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    

    output$view_map <- renderLeaflet({
        if(is.na(input$xlon) | is.na(input$ylat)){
            return(NULL)
        }
        
        point_location <- data.frame(lng = input$xlon, lat = input$ylat)
        leaflet() %>% 
            setView(lng = point_location$lng[1], lat = point_location$lat[1], zoom = 12) %>% 
            addMarkers(data = point_location) %>% 
            addProviderTiles(providers$OpenStreetMap)
    })   
    
    # End application after closing a window or tab
    session$onSessionEnded(stopApp)
}

# Run the application 
shinyApp(ui = ui, server = server)
