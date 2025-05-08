#' main_summary ui function
#'
#' @description main_summary ui
#'
#' @noRd
ui_main_summary <- function(id) {
  ns <- NS(id)

  tagList(
    bslib::card(
      fill = T,
      full_screen = T,
      bslib::card_header(
        class = "stryker-yellow",
        style = "height: 40px; padding: 0px; margin: 0px;",
        tags$div(
          class = "header-left",
          tags$h6(
            style = "margin-bottom: 20px;",
            "Time Series by"
          ),
          selectInput(
            inputId = ns("by"),
            label = NULL,
            choices = c("Region", "Territory", "ProductCategory"),
            selected = "Region",
            selectize = F
          ) |>
            tagAppendAttributes(
              style = "margin-left: 10px !important; padding: 0px !important; margin-bottom: 10px; !important"
            )
        )
      ),
      bslib::card_body(
        fillable = T,
        fill = T,
        style = "height: 50vh;",
        echarts4r::echarts4rOutput(
          outputId = ns("chart")
        )
      )
    ),
    bslib::card(
      fill = T,
      full_screen = T,
      bslib::card_header(
        class = "stryker-yellow",
        style = "height: 40px; padding: 0px; margin: 0px;",
        tags$div(
          class = "header-left",
          tags$h6(
            style = "margin-bottom: 20px;",
            "Data (top 1000 rows)"
          )
        )
      ),
      bslib::card_body(
        fillable = T,
        fill = T,
        style = "height: 50vh;",
        reactable::reactableOutput(
          outputId = ns("table")
        ),
        actionButton(
          inputId = ns("delete"),
          label = "Delete Row"
        )
      )
    )
  )
}

#' main_summary server function
#'
#' @description main_summary server
#'
#' @noRd
server_main_summary <- function(id, rv){
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    ## watch by ----
    observeEvent(input$by, {
      rv$trigger_render_summary_chart <- rv$trigger_render_summary_chart + 1
    })

    ## output chart ----
    output$chart <- echarts4r::renderEcharts4r({
      req(rv$trigger_render_summary_chart)
      isolate({
        by <- input$by
        req(rv$filtered) |>
          dplyr::mutate(ShipDate = lubridate::floor_date(ShipDate, "month")) |>
          dplyr::summarise(
            TotalDue = round(sum(TotalDue, na.rm = T), 0),
            .by = c("ShipDate", by)
          ) |>
          dplyr::group_by(!!sym(by)) |>
          echarts4r::e_charts(ShipDate) |>
          echarts4r::e_title(glue::glue("Amount Due Trend by {by}")) |>
          echarts4r::e_tooltip(trigger = "axis") |>
          echarts4r::e_bar(TotalDue)
      })
    })

    ## output table ----
    output$table <- reactable::renderReactable({
      req(rv$trigger_render_summary_table)
      isolate({
        req(rv$filtered) |>
          dplyr::arrange(dplyr::desc(SalesOrderID)) |>
          head(1000) |>
          reactable::reactable(
            compact = T,
            fullWidth = F,
            width = "100%",
            highlight = T,
            wrap = F,
            sortable = F,
            resizable = T,
            defaultPageSize = 10,
            selection = "multiple",
            ### Highlight new records ----
            # rowStyle = function(index) {
            #   if (rv$filtered$ShipDate[index] > Sys.Date() - 300) {
            #     list(background = "#ffebee")
            #   }
            # },
            columns = list(
              .selection = reactable::colDef(show = T),
              SalesOrderID = reactable::colDef(
                name = "OrderID",
                show = T
              ),
              Region = reactable::colDef(
                name = "Region",
                show = T
              ),
              Territory = reactable::colDef(
                name = "Territory",
                show = T
              ),
              ProductCategory = reactable::colDef(
                name = "Category",
                show = T
              ),
              ProductSubCategory = reactable::colDef(
                name = "SubCategory",
                show = T
              ),
              Product = reactable::colDef(
                name = "Product",
                show = T
              ),
              OnlineOrderFlag = reactable::colDef(
                name = "Online",
                show = T
              ),
              ShipDate = reactable::colDef(
                name = "ShipDate",
                show = T
              ),
              TotalDue = reactable::colDef(
                name = "TotalDue",
                show = T
              )
            ),
            defaultColDef = reactable::colDef(show=F)
          )
      })
    })

    ## selected rows ----
    selected <- reactive(reactable::getReactableState("table", "selected"))

    ## update table ----
    observeEvent(rv$trigger_update_summary_table, {
      reactable::updateReactable(
        outputId = "table",
        data = rv$filtered |>
          dplyr::arrange(dplyr::desc(SalesOrderID)) |>
          head(1000)
      )
    }, ignoreInit = T)

    ## watch delete ----
    observeEvent(input$delete, {
      req(selected())
      ### selected orders ----
      orders <- rv$filtered$SalesOrderID[selected()]
      #### save update ----
      rds <- rv$datamart |>
        dplyr::filter(!SalesOrderID %in% c(orders))
      saveRDS(rds, "www/datamart.rds")
      #### update in app ----
      rv$filtered <- rv$filtered |>
        dplyr::filter(!SalesOrderID %in% c(orders))
      #### update visuals ----
      rv$trigger_render_summary_chart <- rv$trigger_render_summary_chart + 1
      rv$trigger_update_summary_table <- rv$trigger_update_summary_table + 1
    })
  })
}
