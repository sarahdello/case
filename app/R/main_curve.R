#' main_curve ui function
#'
#' @description main_curve ui
#'
#' @noRd
ui_main_curve <- function(id) {
  ns <- NS(id)

  bslib::card(
    bslib::card_header(
      class = "stryker-yellow",
      "Cumulative Distribution.... (ran out of time to do this)"
    ),
    bslib::card_body(
      echarts4r::echarts4rOutput(
        outputId = ns("chart")
      )
    )
  )
}

#' main_curve server function
#'
#' @description main_curve server
#'
#' @noRd
server_main_curve <- function(id, rv){
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ## output chart ----
    output$chart <- echarts4r::renderEcharts4r({
      req(rv$trigger_render_curve_chart)
      isolate({
        rv$filtered |>
          e_charts(ShipDate) |>
          e_line(TotalDue) |>
          e_title("Amount Due Trend") |>
          e_tooltip()
      })
    })
  })
}
