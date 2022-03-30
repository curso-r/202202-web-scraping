

u <- "https://dejt.jt.jus.br/dejt/f/n/diariocon"

# passo intermediario para pegar o state

r0 <- httr::GET(u, httr::config(ssl_verifypeer = FALSE))
viewstate <- r0 |>
  xml2::read_html() |>
  xml2::xml_find_first("//input[@name='javax.faces.ViewState']") |>
  xml2::xml_attr("value")

body <- list(
  "corpo:formulario:dataIni" = "29/03/2022",
  "corpo:formulario:dataFim" = "29/03/2022",
  "corpo:formulario:tipoCaderno" = "",
  "corpo:formulario:tribunal" = "",
  "corpo:formulario:ordenacaoPlc" = "",
  "navDe" = "",
  "detCorrPlc" = "",
  "tabCorrPlc" = "",
  "detCorrPlcPaginado" = "",
  "exibeEdDocPlc" = "",
  "indExcDetPlc" = "",
  "org.apache.myfaces.trinidad.faces.FORM" = "corpo:formulario",
  "_noJavaScript" = "false",
  "javax.faces.ViewState" = viewstate,
  "source" = "corpo:formulario:botaoAcaoPesquisar"
)

r <- httr::POST(
  u, body = body, encode = "form",
  httr::config(ssl_verifypeer = FALSE),
  httr::write_disk("output/dejt_test.html", TRUE)
)
