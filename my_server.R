library("dplyr")
library("stringr")
library("shiny")
library("plotly")
library("mapproj")

co2_emission_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

server <- function(input, output) {
  
# Relevant Values of Interest

  co2_data_by_continent <- co2_emission_data %>%
    filter(year >= 2000, na.rm = TRUE) %>%
    filter(
      country %in% c(
        "Asia",
        "North America",
        "South America",
        "Africa",
        "Australia",
        "Europe"
      )
    )
  
# 1. What continent has the highest co2 per capita as of the most recent year of record?

highest_co2_per_capita <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(co2_per_capita == max(co2_per_capita, na.rm = TRUE)) %>%
  pull(country)

# 2. What continent has the lowest co2 per capita as of the most recent year of record?

lowest_co2_per_capita <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(co2_per_capita == min(co2_per_capita, na.rm = TRUE)) %>%
  pull(country)

# 3. Cumulatively, what continent contributed the most to CO2 emissions since the first year of data collection?
highest_cumulative_co2 <-co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(cumulative_co2 == max(cumulative_co2, na.rm = TRUE)) %>%
  pull(country)

# 4. Cumulatively, what continent contributed the least to CO2 emissions since the first year of data collection?
lowest_cumulative_co2 <-co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(cumulative_co2 == min(cumulative_co2, na.rm = TRUE)) %>%
  pull(country)

# 5. What proportion of total co2 emissions came from North America in 2020?

total_co2_in_2020 <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  summarize(co2 = sum(co2, na.rm = TRUE)) %>%
  pull(co2)

north_america_proportion <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(country == "North America") %>%
  summarize(proportion = co2 / total_co2_in_2020) %>%
  pull(proportion)

# 6. What proportion of total co2 emissions came from South America in 2020?

south_america_proportion <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(country == "South America") %>%
  summarize(proportion = co2 / total_co2_in_2020) %>%
  pull(proportion)

# 7. What proportion of total co2 emissions came from Asia in 2020?

asia_proportion <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(country == "Asia") %>%
  summarize(proportion = co2 / total_co2_in_2020) %>%
  pull(proportion)

# 8. What proportion of total co2 emissions came from Europe in 2020?

europe_proportion <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(country == "Europe") %>%
  summarize(proportion = co2 / total_co2_in_2020) %>%
  pull(proportion)

# 9. What proportion of total co2 emissions came from Australia in 2020?

australia_proportion <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(country == "Australia") %>%
  summarize(proportion = co2 / total_co2_in_2020) %>%
  pull(proportion)

# 10. What proportion of total co2 emissions came from Africa in 2020?

africa_proportion <- co2_data_by_continent %>%
  filter(year == max(year, na.rm = TRUE)) %>%
  filter(country == "Africa") %>%
  summarize(proportion = co2 / total_co2_in_2020) %>%
  pull(proportion)


#My plot 

  output$co2_plot <- renderPlotly ({
   # use y_axis_input
    by_year_co2 <- co2_data_by_continent %>%
      filter(country %in% input$continent_input)

    my_plot <- ggplot(data = by_year_co2,
                      aes(
                        x = year,
                        y = !!as.name(input$y_axis_input),
                        color = country)) +
               ggtitle("CO2 Emissions by Industry and Continent") +
               geom_line() +
               geom_point()

    my_plotly_plot <- ggplotly(my_plot)

    return(my_plotly_plot)
  })

}
