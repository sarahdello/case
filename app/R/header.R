#' header ui function
#'
#' @description header ui
#'
#' @noRd
ui_header <- function(id) {
  ns <- NS(id)

  tagList(
    tags$div(
      class = "header-left",
      tags$h5("Stryker Sales Dashboard"),
      actionButton(
        inputId = ns("summary"),
        label = "Summary",
        class = "navbar-button active",
        onclick = glue::glue("Shiny.setInputValue('{ns('navbar')}', remove_ns(this.id));")
      )
      # actionButton(
      #   inputId = ns("data"),
      #   label = "Data",
      #   class = "navbar-button active",
      #   onclick = glue::glue("Shiny.setInputValue('{ns('navbar')}', remove_ns(this.id));")
      # ),
      # actionButton(
      #   inputId = ns("curve"),
      #   label = "Curve",
      #   class = "navbar-button active",
      #   onclick = glue::glue("Shiny.setInputValue('{ns('navbar')}', remove_ns(this.id));")
      # )
    ),
    tags$div(
      class = "header-right",
      actionButton(
        inputId = ns("add"),
        label = "Add Sale",
        class = "navbar-button",
        icon = icon("plus")
      )
    )
  )
}

#' header server function
#'
#' @description header server
#'
#' @noRd
server_header <- function(id, rv){
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ## watch navbar ----
    observeEvent(input$navbar, {
      rv$navbar <- input$navbar
    })

    ## add sale ----
    observeEvent(input$add, {
      req(rv$filtered)
      modalDialog(
        title = "Add Dummy Sale",
        size = "m",
        selectizeInput(
          inputId = ns("product"),
          choices = unique(rv$filtered$Product),
          label = red_star("Select a Product"),
          width = "100%"
        ),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(
            inputId = ns("confirm"),
            label = "Confirm"
          )
        )
      ) |>
        showModal()
    })
    ### confirm ----
    observeEvent(input$confirm, {
      req(nzchar(input$product))
      removeModal()
      #### select random record as template ----
      new_order <- max(rv$filtered$SalesOrderID) + 1
      row <- rv$filtered |>
        dplyr::filter(Product == input$product) |>
        dplyr::slice_sample(n = 1) |>
        dplyr::mutate(
          ShipDate = Sys.Date(),
          SalesOrderID = new_order,
          SalesOrderNumber = paste0("SO", new_order)
        )
      #### save update ----
      rds <- rv$datamart |>
        dplyr::rows_upsert(
          row,
          by = "SalesOrderID"
        )
      saveRDS(rds, "www/datamart.rds")
      #### update in app ----
      rv$filtered <- rv$filtered |>
        dplyr::rows_upsert(
          row,
          by = "SalesOrderID"
        )
      #### update visuals ----
      rv$trigger_render_summary_chart <- rv$trigger_render_summary_chart + 1
      rv$trigger_update_summary_table <- rv$trigger_update_summary_table + 1
    })
  })
}
