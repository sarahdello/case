notify <- function(msg, id, type="message", duration=100) {
  showNotification(
    ui = tagList(
      tags$div(
        tags$strong(msg)
      )
    ),
    type = type,
    duration = duration,
    id = id
  )
}

red_star <- function(text) {
  tags$span(
    HTML(
      paste0(
        text,
        tags$span(
          style = "color: red; font-weight: 900; margin: 2px;",
          "*"
        )
      )
    )
  )
}
