# Make the page
ui <-
  fluidPage(
    
    # Set the title/theme
    titlePanel("Marathon County ACS 2022"),
    theme = shinytheme("cosmo"),
    
    # Typical layout
    sidebarLayout(
      sidebarPanel(
        
        # Select which quantity to display on map
        selectInput(
          inputId = "displayed_var",
          label = "Display variable on map",
          choices = 
            c(
              `Median age` = age,
              `Median income` = income
            )
        ),
        
        # Show a scatter plot
        plotlyOutput(outputId = "rel_plot")
      ),
      mainPanel(
        
        # Make the map output
        maplibreOutput(outputId = "map_display")
        
      )
    )
  )