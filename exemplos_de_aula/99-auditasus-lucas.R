# acessa site desejado
u_site <- "https://auditasus.com.br/destaques/covid19-braasil/covid19-brasil-qtd-leitos-uti-adulto-por-cada-10k-hab-mun"
r_site <- httr::GET(u_site)
token <- r_site |>
  xml2::read_html() |>
  xml2::xml_text() |>
  stringr::str_extract("(?<=csrf\\.token\":\")[0-9a-z]+")

u <- "https://auditasus.com.br/auditasus-login?task=user.login"

# readRenviron(".Renviron")

body <- list(
  "username" = "jtrecenti",
  "password" = Sys.getenv("AUDITASUS_PWD"),
  # colocar o token aqui
  "token" = 1
)
names(body)[3] <- token

r <- httr::POST(
  u, body = body, encode = "form"
)

# scrapr::html_view(r)

r_site <- httr::GET(
  u_site,
  httr::write_disk("output/teste_dados.html", TRUE)
)

# scrapr::html_view(r_site)

dados <- r_site |>
  xml2::read_html() |>
  xml2::xml_find_first("//table[@class='plots1']") |>
  rvest::html_table() |>
  janitor::row_to_names(1) |>
  janitor::clean_names()

#' Aula 1:
#' - politica de web scraping
#' - limites do web scraping
#' - 4 tipos de problemas principais (API documentada,
#' API escondida, HTML estático, HTML dinâmico)
#' - Ciclo do web scraping (navegar, imitar, __acessar__, validar, iterar)
#' - Exemplo: API documentada (brasil API)
#' - Exemplo: API escondida (sabesp)
#'
#' Aula 2: "autenticação"
#' - Exemplo: SPtrans
#' - Exemplo: Twitter
#' - Exemplo: Covid-19 (msaude) (dificil)
#'
#' Aula 3: HTML
#' - HTML, DOM, pacote xml2
#' - Exemplo: chance de gol
#' - Exemplo: tjsp (dificil)
#' - xpath
#'
#' Aula 4: Iteração
#' - purrr::map
#' - processamento paralelo
#' - funções com tratamento de erros
#' - barras de progresso
#' - Exemplos: wikipedia, duckduckgo
#'
#' Aula 5: Páginas dinâmicas
#' - webdriver: é mais fácil, mas não funciona sempre, e usa phantomJS
#' - RSelenium: funciona mais, mas tem uma sintaxe mais complexa
#' - Exemplo muito dificil do exercício da wiki
#'
#'
#' Aula 6:

# conectando no docker
library(RSelenium)
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L
)
remDr$open()

remDr$navigate("https://google.com")
remDr$screenshot(display = TRUE)

remDr$close()
