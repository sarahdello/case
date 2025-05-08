#' sidebar ui function
#'
#' @description sidebar ui
#'
#' @noRd
ui_sidebar <- function(id) {
  ns <- NS(id)
  bslib::accordion(
    bslib::accordion_panel(
      title = "Filters",
      open = T,
      tags$div(
        tags$strong("Region"),
        selectizeInput(
          inputId = ns("Region"),
          label = NULL,
          choices = NULL,
          multiple = T,
          width = "100%",
          options = list(
            maxOptions = 10,
            plugins = "remove_button",
            onChange = I(
              "function(value) {
              var id = $(this.$input).attr('id');
              Shiny.setInputValue(id + '_changed', {value: value}, {priority: 'event'});
            }"
            )
          )
        )
      ),
      tags$div(
        tags$strong("Territory"),
        selectizeInput(
          inputId = ns("Territory"),
          label = NULL,
          choices = NULL,
          multiple = T,
          width = "100%",
          options = list(
            maxOptions = 10,
            plugins = "remove_button",
            onChange = I(
              "function(value) {
              var id = $(this.$input).attr('id');
              Shiny.setInputValue(id + '_changed', {value: value}, {priority: 'event'});
            }"
            )
          )
        )
      ),
      tags$div(
        tags$strong("ProductCategory"),
        selectizeInput(
          inputId = ns("ProductCategory"),
          label = NULL,
          choices = NULL,
          multiple = T,
          width = "100%",
          options = list(
            maxOptions = 10,
            plugins = "remove_button",
            onChange = I(
              "function(value) {
              var id = $(this.$input).attr('id');
              Shiny.setInputValue(id + '_changed', {value: value}, {priority: 'event'});
            }"
            )
          )
        )
      ),
      tags$div(
        tags$strong("ProductSubCategory"),
        selectizeInput(
          inputId = ns("ProductSubCategory"),
          label = NULL,
          choices = NULL,
          multiple = T,
          width = "100%",
          options = list(
            maxOptions = 10,
            plugins = "remove_button",
            onChange = I(
              "function(value) {
              var id = $(this.$input).attr('id');
              Shiny.setInputValue(id + '_changed', {value: value}, {priority: 'event'});
            }"
            )
          )
        )
      ),
      tags$div(
        tags$strong("Product"),
        selectizeInput(
          inputId = ns("Product"),
          label = NULL,
          choices = NULL,
          multiple = T,
          width = "100%",
          options = list(
            maxOptions = 10,
            plugins = "remove_button",
            onChange = I(
              "function(value) {
              var id = $(this.$input).attr('id');
              Shiny.setInputValue(id + '_changed', {value: value}, {priority: 'event'});
            }"
            )
          )
        )
      ),
      tags$div(
        tags$strong("OnlineOrderFlag"),
        selectizeInput(
          inputId = ns("OnlineOrderFlag"),
          label = NULL,
          choices = NULL,
          multiple = T,
          width = "100%",
          options = list(
            maxOptions = 10,
            plugins = "remove_button",
            onChange = I(
              "function(value) {
              var id = $(this.$input).attr('id');
              Shiny.setInputValue(id + '_changed', {value: value}, {priority: 'event'});
            }"
            )
          )
        )
      ),
      tags$div(
        tags$strong("ShipDate"),
        dateRangeInput(
          inputId = ns("ShipDate"),
          label = NULL,
          width = "100%",
          start = as.Date("2011-01-01"),
          end = as.Date("2014-12-01")
        )
      )
    )
  )
}

#' sidebar server function
#'
#' @description sidebar server
#'
#' @noRd
server_sidebar <- function(id, rv){
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent("init", {
      rv$mapping <- c(
        "Region",
        "Territory",
        "ProductCategory",
        "ProductSubCategory",
        "Product",
        "OnlineOrderFlag"
      )
    })

    ## watch Region ----
    observeEvent(input$Region_changed, {
      value <- unname(unlist(input$Region_changed))
      rv$filters$Region <- value
      rv$entry <- "Region"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## watch Territory ----
    observeEvent(input$Territory_changed, {
      value <- unname(unlist(input$Territory_changed))
      rv$filters$Territory <- value
      rv$entry <- "Territory"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## watch ProductCategory ----
    observeEvent(input$ProductCategory_changed, {
      value <- unname(unlist(input$ProductCategory_changed))
      rv$filters$ProductCategory <- value
      rv$entry <- "ProductCategory"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## watch ProductSubCategory ----
    observeEvent(input$ProductSubCategory_changed, {
      value <- unname(unlist(input$ProductSubCategory_changed))
      rv$filters$ProductSubCategory <- value
      rv$entry <- "ProductSubCategory"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## watch Product ----
    observeEvent(input$Product_changed, {
      value <- unname(unlist(input$Product_changed))
      rv$filters$Product <- value
      rv$entry <- "Product"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## watch OnlineOrderFlag ----
    observeEvent(input$OnlineOrderFlag_changed, {
      value <- unname(unlist(input$OnlineOrderFlag_changed))
      rv$filters$OnlineOrderFlag <- value
      rv$entry <- "OnlineOrderFlag"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## watch ShipDate ----
    observeEvent(input$ShipDate, {
      value <- input$ShipDate
      rv$filters$ShipDate <- value
      rv$entry <- "ShipDate"
      rv$trigger_update_filtered_data <- rv$trigger_update_filtered_data + 1
    }, ignoreInit = T)

    ## update selectizes ----
    observeEvent(rv$trigger_update_filters, {
      filters <- rv$filters
      ids <- rv$mapping
      if (is.null(filters)) {
        rv$entry <- ""
      }
      for (i in seq_along(ids)) {
        id <- as.character(ids[i])
        ### ignore itself ----
        if (id == rv$entry) next
        col <- id
        selected <- as.character(filters[col])
        choices <- sort(unique(rv$filtered[[col]]))
        updateSelectizeInput(
          session = session,
          inputId = id,
          selected = selected,
          choices = choices
        )
      }
    }, ignoreInit = T)
  })
}
