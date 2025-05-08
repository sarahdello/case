#' app ui function
#'
#' @description app ui entry
#'
#' @noRd
ui <- bslib::page(
  shinyjs::useShinyjs(),
  title = "Stryker Sales Dashboard",
  theme = bslib::bs_theme(
    preset = "flatly",
    font_scale = 0.95,
    `enable-rounded` = FALSE,
    `enable-transitions` = FALSE
  ),
  ## css ----
  tags$head(
    style = "display: none;",
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  ## content ----
  bslib::card(
    class = "main",
    full_screen = F,
    fill = T,
    bslib::card_header(
      class = "header stryker-yellow",
      ui_header(
        id = "header"
      )
    ),
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        width = 300,
        ui_sidebar(
          id = "sidebar"
        )
      ),
      bslib::card_body(
        fillable = T,
        fill = T,
        ui_main(
          id = "main"
        )
      )
    )
  ),
  ## js ----
  tags$footer(
    style = "display: none;",
    tags$script(type = "text/javascript", src = "utils.js")
  )
)

#' app server function
#'
#' @description app server entry
#'
#' @noRd
server <- function(input, output) {

  ## sub-modules ----
  server_header(
    id = "header",
    rv = rv
  )
  server_sidebar(
    id = "sidebar",
    rv = rv
  )
  server_main(
    id = "main",
    rv = rv
  )

  ## app rv ----
  rv <- reactiveValues(
    trigger_update_filtered_data = 1,
    trigger_update_filters = 1,
    trigger_filter_down = 1,
    # just put everything on one menu
    trigger_render_summary_chart = 1,
    trigger_render_summary_table = 1,
    trigger_update_summary_table = 1,
    # not enough time
    # trigger_render_curve_chart = 1,
    # trigger_render_data_table = 1
    filtered = tibble::tibble(
      SalesOrderID = numeric(0),
      SalesOrderNumber = character(0),
      CountryRegionCode = character(0),
      Region = character(0),
      Territory = character(0),
      Product = character(0),
      ProductCategory = character(0),
      ProductSubCategory = character(0),
      OnlineOrderFlag = character(0),
      StandardCost = numeric(0),
      ListPrice = numeric(0),
      SubTotal = numeric(0),
      TaxAmt = numeric(0),
      Freight = numeric(0),
      TotalDue = numeric(0),
      UnitPrice = numeric(0),
      UnitPriceDiscount = numeric(0),
      LineTotal = numeric(0),
      DueDate = as.Date(character(0)),
      OrderDate = as.Date(character(0)),
      ShipDate = as.Date(character(0))
    )
  )

  ## init ----
  observeEvent("init", {
    ### check if datamart csv exists ----
    dm <- file.exists("www/datamart.rds")
    if (dm) {
      notify("Loading datamart...", id = "load")
      rv$datamart <- readRDS("www/datamart.rds") |>
        dplyr::arrange(dplyr::desc(SalesOrderID)) |>
        suppressWarnings()
      removeNotification(id = "load")
      rv$filtered <- rv$datamart |>
        dplyr::select(dplyr::any_of(names(rv$filtered))) |>
        dplyr::arrange(dplyr::desc(SalesOrderID))
      ### trigger update ----
      rv$trigger_update_filters <- rv$trigger_update_filters + 1
      rv$trigger_render_summary_chart <- rv$trigger_render_summary_chart + 1
      rv$trigger_render_summary_table <- rv$trigger_render_summary_table + 1
      return()
    }
    notify("Loading excel data... slow 🐌", id = "load")
    ### read all sheets ----
    # this is very slow and would be a db in production
    # in the interest of doing everything from scratch on the fly with the raw data I went this route
    sheets <- readxl::excel_sheets("www/Business Analytics - Case Study Data.xlsx")
    for (i in seq_along(sheets)) {
      rv$data[[sheets[i]]] <- readxl::read_xlsx(
        path = paste0("www/Business Analytics - Case Study Data.xlsx"),
        sheet = sheets[i]
      ) |>
        suppressWarnings()
    }
    removeNotification(id = "load")
    rv$trigger_datamart <- 1
  })
}

#' shinyApp
#'
#' @description run app
#'
#' @noRd
shinyApp(ui = ui, server = server)
