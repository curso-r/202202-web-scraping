library(tidyverse)
library(httr)

u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"

u_sptrans_busca <- paste0(u_sptrans, endpoint)
r_sptrans <- httr::GET(u_sptrans_busca)
content(r_sptrans)

# usethis::edit_r_environ("project")

# api_key <- Sys.getenv("API_OLHO_VIVO")
api_key <- "4af5e3112da870ac5708c48b7a237b30206806f296e1d302e4cb611660e2e03f"
u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")

r_sptrans_login <- POST(
  u_sptrans_login,
  query = list(token = api_key)
)
httr::content(r_sptrans_login)



r_sptrans <- httr::GET(u_sptrans_busca)
resultados <- content(r_sptrans)

dados <- resultados$l |>
  purrr::map(tibble::as_tibble) |>
  dplyr::bind_rows()

jsonlite::fromJSON()
resultados <- content(r_sptrans, simplifyDataFrame = TRUE)

resultados$l |>
  tibble::as_tibble() |>
  tidyr::unnest(vs) |>
  ggplot(aes(px, py)) +
  geom_point(alpha = .2) +
  coord_equal()
