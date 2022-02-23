u_base_sabesp <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
data_consulta <- "2022-02-09"
data_consulta2 <- "2022-02-10"
u_sabesp <- paste0(u_base_sabesp, data_consulta)
r_sabesp <- httr::GET(u_sabesp, httr::config(ssl_verifypeer = FALSE))

httr::httr_options() |> View()

tabela <- r_sabesp |>
  httr::content(simplifyDataFrame = TRUE) |>
  purrr::pluck("ReturnObj", "sistemas")

# TODO: transformar isso numa função
u_sabesp2 <- paste0(u_base_sabesp, data_consulta2)
r_sabesp2 <- httr::GET(u_sabesp2, httr::config(ssl_verifypeer = FALSE))

tabela2 <- r_sabesp2 |>
  httr::content(simplifyDataFrame = TRUE) |>
  purrr::pluck("ReturnObj", "sistemas")


datas <- seq(
  as.Date("2022-02-01"),
  as.Date("2022-02-21"),
  "1 day"
)

cria_tabela <- function(data_consulta) {

  u_sabesp <- paste0(u_base_sabesp, data_consulta)
  r_sabesp <- httr::GET(u_sabesp, httr::config(ssl_verifypeer = FALSE))

  tabela <- r_sabesp |>
    httr::content(simplifyDataFrame = TRUE) |>
    purrr::pluck("ReturnObj", "sistemas")

  tabela
}

cria_tabela(datas[2])

resultados <- purrr::map(datas, cria_tabela)

length(resultados)
resultados[[2]]

dplyr::bind_rows(resultados)

# purrr::map_dfr()

lista <- list(
  nome = "julio",
  endereco = list(
    rua = "dos bobos",
    numero = "zero"
  )
)

lista$endereco$numero

lista |>
  purrr::pluck("endereco", "numero")
