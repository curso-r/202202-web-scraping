### PURRR ----------------------------------

v <- 10:19
for (i in seq_along(v)) {
  v[i] <- v[i] * 2
}
v

w <- 20:29
for (i in seq_along(w)) {
  w[i] <- w[i] * 3
}
w

w <- 20:29
for (i in seq_along(w)) {
  w[i] <- w[i] * 2
}
w

# Uma entrada (vetor)
# Uma função
# Aplico a função em cada elemento da entrada

library(purrr)

vezes2 <- function(n) n * 2

map(10:19, vezes2)
map_dbl(10:19, vezes2)

vezes3 <- function(n) n * 3

map_dbl(20:29, vezes3)
map_dbl(20:29, vezes2)

# map = mapa (cartografia)
# map = mapear (criar uma relação)

### WEB SCRAPING ---------------------------

library(xml2)

# Setup
base <- "https://en.wikipedia.org/wiki/"
urls <- paste0(base, c(
  "R_(programming_language)",
  "Python_(programming_language)"
))

# Programador(a) desavisado(a)
titulos <- c()
for (i in seq_along(urls)) {
  url <- urls[i]
  titulo <- url |>
    read_html() |>
    xml_find_first("//h1") |>
    xml_text()

  titulos <- c(titulos, titulo)
}
titulos

# Um map para cada operação
htmls <- map(urls, read_html)
nodes <- map(htmls, xml_find_first, "//h1")
texts <- map_chr(nodes, xml_text)
texts

# Pipeline de maps
urls |>
  map(read_html) |>
  map(xml_find_first, "//h1") |>
  map_chr(xml_text)

# Map de uma função só
extrair_h1 <- function(url) {
  url |>
    read_html() |>
    xml_find_first("//h1") |>
    xml_text()
}
map_chr(urls, extrair_h1)

# Um erro
urls <- c("https://site.errado", urls)

# Programador(a) desavisado(a)
titulos <- c()
for (i in seq_along(urls)) {
  url <- urls[i]
  titulo <- url |>
    read_html() |>
    xml_find_first("//h1") |>
    xml_text()

  titulos <- c(titulos, titulo)
}
titulos

# Erro no map também
map_chr(urls, extrair_h1)

# Tratamento de erro
possivelmente_extrair_h1 <- possibly(
  extrair_h1, ""
)

# Agora sim
map_chr(urls, possivelmente_extrair_h1)

### FURRR ----------------------------------

# library(future)
# availableCores()

library(progressr)

# Função que demora 1s
dormir <- function(x, barra) {
  barra()
  Sys.sleep(1)
}

# Map com contexto do progressr
with_progress({
  barra <- progressor(16)
  map(1:16, dormir, barra)
})

library(furrr)

# Não funciona no Windows nem no RStudio
plan(multicore)

# Future map com contexto do progressr
with_progress({
  barra <- progressor(16)
  future_map(1:16, dormir, barra)
})

# Funciona sempre
plan(multisession)

# Future map com contexto do progressr
with_progress({
  barra <- progressor(16)
  future_map(1:16, dormir, barra)
})

# Extrair com barra de progresso
extrair_h1_barra <- function(url, barra) {
  barra()
  url |>
    read_html() |>
    xml_find_first("//h1") |>
    xml_text()
}
possivelmente_extrair_h1_barra <- possibly(
  extrair_h1_barra, ""
)

# Web scraping em paralelo com barra de progresso
with_progress({
  barra <- progressor(length(urls))
  future_map_chr(
    urls,
    possivelmente_extrair_h1_barra,
    barra
  )
})
