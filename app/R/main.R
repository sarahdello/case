#' main ui function
#'
#' @description main ui
#'
#' @noRd
ui_main <- function(id) {
  ns <- NS(id)

  tagList(
    tags$div(
      id = ns("div_summary"),
      style = "height: 120vh;",
      ui_main_summary(
        id = ns("summary")
      )
    ),
    tags$div(
      id = ns("div_curve"),
      ui_main_curve(
        id = ns("curve")
      )
    )|>
      shinyjs::hidden(),
    tags$div(
      id = ns("div_data"),
      ui_main_data(
        id = ns("data")
      )
    ) |>
      shinyjs::hidden()
  )
}

#' main server function
#'
#' @description main server
#'
#' @noRd
server_main <- function(id, rv){
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ## init ----
    observeEvent("init", {
      trigger_update_filters = 1
      # this is subset of data to display in app
      # rv$filtered <- tibble::tibble(
      #   SalesOrderID = numeric(0),
      #   SalesOrderNumber = character(0),
      #   CountryRegionCode = character(0),
      #   Region = character(0),
      #   Territory = character(0),
      #   Product = character(0),
      #   ProductCategory = character(0),
      #   ProductSubCategory = character(0),
      #   OnlineOrderFlag = character(0),
      #   StandardCost = numeric(0),
      #   ListPrice = numeric(0),
      #   SubTotal = numeric(0),
      #   TaxAmt = numeric(0),
      #   Freight = numeric(0),
      #   TotalDue = numeric(0),
      #   UnitPrice = numeric(0),
      #   UnitPriceDiscount = numeric(0),
      #   LineTotal = numeric(0),
      #   DueDate = as.Date(character(0)),
      #   OrderDate = as.Date(character(0)),
      #   ShipDate = as.Date(character(0))
      # )
    })

    ## watch navbar ----
    observeEvent(rv$navbar, {
      if (rv$navbar == "summary") {
        shinyjs::hide(id = "div_curve")
        shinyjs::hide(id = "div_data")
        shinyjs::show(id = "div_summary")
        return()
      }
      if (rv$navbar == "curve") {
        shinyjs::hide(id = "div_summary")
        shinyjs::hide(id = "div_data")
        shinyjs::show(id = "div_curve")
        return()
      }
      if (rv$navbar == "data") {
        shinyjs::hide(id = "div_summary")
        shinyjs::hide(id = "div_curve")
        shinyjs::show(id = "div_data")
        return()
      }
    })

    ## sub-modules ----
    server_main_summary(
      id = "summary",
      rv = rv
    )
    server_main_curve(
      id = "curve",
      rv = rv
    )
    server_main_data(
      id = "data",
      rv = rv
    )

    ## watch datamart ----
    observeEvent(rv$trigger_datamart, {
      ### create single table datamart ----
      # this would be prod dataset I query from vs looping through excel sheets
      notify("Creating datamart...", id = "create")
      rv$datamart <- rv$data$SalesOrderHeader |>
        dplyr::left_join(
          rv$data$SalesOrderDetail,
          by = "SalesOrderID"
        ) |>
        dplyr::left_join(
          rv$data$Product |> dplyr::rename(Product=Name),
          by = "ProductID"
        ) |>
        dplyr::left_join(
          rv$data$Customers |> dplyr::select(CustomerID, PersonID, StoreID),
          by = "CustomerID"
        ) |>
        dplyr::left_join(
          rv$data$SalesTerritory |> dplyr::rename(Territory=Name, Region=Group),
          by = "TerritoryID"
        ) |>
        dplyr::left_join(
          # grab first for dups
          rv$data$StoreCustomers |>
            dplyr::distinct(BusinessEntityID, .keep_all = T) |>
            dplyr::rename(Store=Name),
          by = c("BillToAddressID" = "BusinessEntityID"),
          suffix = c(".x", "Store")
        ) |>
        dplyr::left_join(
          # grab first for dups
          rv$data$IndividualCustomers |> dplyr::distinct(BusinessEntityID, .keep_all = T),
          by = c("BillToAddressID" = "BusinessEntityID"),
          suffix = c("Store", "Individual")
        ) |>
        dplyr::left_join(
          rv$data$ProductSubCategory |> dplyr::rename(ProductSubCategory=Name),
          by = c("ProductSubcategoryID")
        ) |>
        dplyr::left_join(
          rv$data$ProductCategory |> dplyr::rename(ProductCategory=Name),
          by = c("ProductCategoryID")
        )
      ### cleanup ----
      nms <- sort(names(rv$datamart))
      rv$datamart <- rv$datamart |>
        dplyr::select(dplyr::all_of(nms)) |>
        dplyr::mutate(
          OnlineOrderFlag = ifelse(OnlineOrderFlag, "Yes", "No"),
          ShipDate = as.Date(ShipDate),
          DueDate = as.Date(DueDate),
          OrderDate = as.Date(OrderDate)
        ) |>
        dplyr::arrange(dplyr::desc(SalesOrderID))
      rds <- rv$datamart
      saveRDS(rds, "www/datamart.rds")
      removeNotification(id = "create")
      ### create subset ----
      rv$filtered <- rv$datamart |>
        dplyr::select(dplyr::any_of(names(rv$filtered))) |>
        dplyr::arrange(dplyr::desc(SalesOrderID))
      ### trigger update ----
      rv$trigger_update_filters <- rv$trigger_update_filters + 1
      rv$trigger_render_summary_chart <- rv$trigger_render_summary_chart + 1
      rv$trigger_render_summary_table <- rv$trigger_render_summary_table + 1
    })

    ## watch filters ----
    observeEvent(rv$trigger_update_filtered_data, {
      removeNotification(id = "filter")
      filters <- rv$filters
      cols <- names(filters)
      data <- rv$datamart
      notify("Filtering...", id = "filter")
      for (i in seq_along(filters)) {
        col <- cols[i]
        if (col == "ShipDate") {
          data <- data |>
            dplyr::filter(ShipDate >= filters$ShipDate[1], ShipDate <= filters$ShipDate[2])
          next
        }
        data <- data |>
          dplyr::filter(.data[[col]] %in% c(filters[[col]]))
      }
      rv$filtered <- data
      rv$trigger_update_filters <- rv$trigger_update_filters + 1
      rv$trigger_render_summary_chart <- rv$trigger_render_summary_chart + 1
      rv$trigger_render_summary_table <- rv$trigger_render_summary_table + 1
      removeNotification(id = "filter")
    }, ignoreInit = T)
  })
}
