library(httr)
library(xml2)
library(stringr)
library(tibble)
library(purrr)
library(progressr)
library(furrr)
plan(multisession)

# Home do site
home <- "https://realpython.github.io/fake-jobs/"

# Outra opção de XPath:
# "//a[@class='card-footer-item' and text() = 'Apply']"
links <- home |>
  GET() |>
  content() |>
  xml_find_all("//a[@class='card-footer-item'][2]") |>
  xml_attr("href")

# Extrair dados de uma vaga
extrair_dados <- function(html) {

  # Nome da vaga
  vaga <- html |>
    xml_find_first("//h1[@class='title is-2']") |>
    xml_text()

  # Nome da empresa
  empresa <- html |>
    xml_find_first("//h2") |>
    xml_text()

  # Descrição da vaga
  descricao <- html |>
    xml_find_first("//div[@class='content']/p") |>
    xml_text()

  # Cidade da vaga
  cidade <- html |>
    xml_find_first("//p[@id='location']") |>
    xml_text() |>
    str_remove(".+: ?")

  # Data de publicação
  data <- html |>
    xml_find_first("//p[@id='date']") |>
    xml_text() |>
    str_remove(".+: ?") |>
    as.Date()

  tibble(
    vaga = vaga,
    empresa = empresa,
    descricao = descricao,
    cidade = cidade,
    data = data
  )
}

# Requisitar página de vaga e extrair dados
pegar_vaga <- function(link, barra) {
  barra()
  link |>
    GET() |>
    content() |>
    extrair_dados()
}

# Tratar erros
possivelmente_pegar_vaga <- possibly(
  pegar_vaga, tibble()
)

# Tudo junto, com tudo que aprendemos
with_progress({
  barra <- progressor(length(links))
  dados <- future_map_dfr(
    links,
    possivelmente_pegar_vaga,
    barra
  )
})

# Examinar tabela
dados
