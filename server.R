server <-
  function(input, output, session) {
    
    # Show the relationship plot
    output$rel_plot <- renderPlotly({rel_plot})
    
    # Get the mapping data
    map_dat <- 
      reactive({
        
        dat |> 
          
          # Filter to selected variable
          filter(variable == input$displayed_var) |>
          
          # Make the popup text
          mutate(
            Info = paste0(str_remove(NAME, ";.+$"), "<br>", get_title(), ": ", round(estimate))
          )
        
      })
    
    # Generate a title
    get_title <- 
      reactive({
        
        if(input$displayed_var == age) {
          
          "Median age (years)"
          
        } else {
          
          "Median income ($)"
          
        }
        
      })
    
    # Create the map based on the selected variable
    output$map_display <- 
      renderMaplibre({
        
        maplibre() |>
          
          # Focus the mapping area
          fit_bounds(map_dat()) |>
          
          # Fill with the data values
          add_fill_layer(
            id = "mc_acs",
            source = map_dat(),
            fill_color = 
              interpolate(
                column = "estimate",
                values = range(map_dat()$estimate, na.rm = TRUE),
                stops = c("#f2d37c", "#08519c"),
                na_color = "gray"
              ),
            fill_opacity = 0.50,
            popup = "Info"
          ) |>
          add_legend(
            legend_title = get_title(),
            values = range(map_dat()$estimate, na.rm = TRUE),
            colors = c("#f2d37c", "#08519c")
          )
        
      })
    
  }