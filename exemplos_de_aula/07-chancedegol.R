library(httr)
library(xml2)
library(tidyverse)

u_cdg <- "https://www.chancedegol.com.br/br21.htm"

r_cdg <- GET(u_cdg)

# daria para pegar no navegador... /html/body/div/font/table
tabela <- r_cdg |>
  read_html() |>
  xml_find_first("//table") |>
  rvest::html_table(header = TRUE) |>
  janitor::clean_names()

# alternativa com janitor::row_to_names()
tabela <- r_cdg |>
  read_html() |>
  xml_find_first("//table") |>
  rvest::html_table() |>
  janitor::row_to_names(1) |>
  janitor::clean_names()

prob_ganhou <- r_cdg |>
  read_html() |>
  xml_find_all("//font[@color='#FF0000']") |>
  xml_text()

tabela_arrumada <- tabela |>
  mutate(ganhou = prob_ganhou) |>
  mutate(quem_ganhou = case_when(
    ganhou == vitoria_do_mandante ~ "mandante",
    ganhou == empate ~ "empate",
    ganhou == vitoria_do_visitante ~ "visitante"
  ))


# alternativa!
tabela |>
  separate(
    x, c("gols_mandante", "gols_visitante"), sep = "x",
    convert = TRUE
  ) |>
  mutate(quem_ganhou = case_when(
    gols_mandante > gols_visitante ~ "mandante",
    gols_mandante == gols_visitante ~ "empate",
    gols_mandante < gols_visitante ~ "visitante"
  ))
