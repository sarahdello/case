#' main_data ui function
#'
#' @description main_data ui
#'
#' @noRd
ui_main_data <- function(id) {
  ns <- NS(id)

  bslib::card(
    bslib::card_header(
      class = "stryker-yellow",
      "Data"
    ),
    bslib::card_body(
      reactable::reactableOutput(
        outputId = ns("table")
      )
    )
  )
}

#' main_data server function
#'
#' @description main_data server
#'
#' @noRd
server_main_data <- function(id, rv){
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ## output table ----
    output$table <- reactable::renderReactable({
      req(rv$trigger_render_data_table)
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
