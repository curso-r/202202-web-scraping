

u_msaude <- "https://covid.saude.gov.br"
r_msaude <- httr::GET(u_msaude,
                      httr::write_disk("output/msaude.html"))


# vamos pelo link que aparece na aba network
u_covid <- "https://mobileapps.saude.gov.br/esus-vepi/files/unAFkcaNDeXajurGB7LChj8SgQYS2ptm/eb7d242583455d1def07101098cca54e_HIST_PAINEL_COVIDBR_22fev2022.7z"

r_msaude <- httr::GET(
  u_covid,
  httr::write_disk("output/dados.7z")
)


# vamos tentar encontrar onde está o arquivo 7z ---------------------------

u_portal_geral <- "https://qd28tcd6b5.execute-api.sa-east-1.amazonaws.com/prod/PortalGeral"
r_portal_geral <- httr::GET(u_portal_geral)

httr::content(r_portal_geral)

# vamos tentar com o header agora

r_portal_geral <- httr::GET(
  u_portal_geral,
  httr::add_headers("x-parse-application-id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
)

resultado <- httr::content(r_portal_geral)
link_7z <- resultado$results[[1]]$arquivo$url
httr::GET(link_7z, httr::write_disk("output/dados_covid.7z"))

# vamos tentar descobrir o application id
u_js <- "https://covid.saude.gov.br/main-es2015.js"
r_js <- httr::GET(u_js)

texto_js <- httr::content(r_js, "text", encoding = "latin1")
rx_js <- "(?<=PARSE_APP_ID = ')[^']+"
app_id <- stringr::str_extract(texto_js, rx_js)


# solucao completa! -------------------------------------------------------
# passo 1: descobrir o app id
u_js <- "https://covid.saude.gov.br/main-es2015.js"
r_js <- httr::GET(u_js)
texto_js <- httr::content(r_js, "text", encoding = "latin1")
rx_js <- "(?<=PARSE_APP_ID = ')[^']+"
app_id <- stringr::str_extract(texto_js, rx_js)
# passo 2: acessar o portal geral
u_portal_geral <- "https://qd28tcd6b5.execute-api.sa-east-1.amazonaws.com/prod/PortalGeral"
r_portal_geral <- httr::GET(
  u_portal_geral,
  httr::add_headers("x-parse-application-id" = app_id)
)
# passo 3: baixar o arquivo
resultado <- httr::content(r_portal_geral)
link_7z <- resultado$results[[1]]$arquivo$url
httr::GET(link_7z, httr::write_disk("output/dados_covid_novo.7z"))




