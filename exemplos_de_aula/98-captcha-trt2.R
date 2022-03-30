## instalar os pacote captcha e captchaDownload
# remotes::install_github("decryptr/captcha@dataset", force = TRUE)
# remotes::install_github("jtrecenti/captchaDownload", force = TRUE)


id_processo <- "1001273-64.2019.5.02.0611"

u_id <- paste0(
  "https://pje.trt2.jus.br/pje-consulta-api/api/processos/dadosbasicos/",
  id_processo
)

r_id <- httr::GET(
  u_id,
  httr::add_headers("x-grau-instancia" = 1)
)

u_pesquisa <- paste0(
  "https://pje.trt2.jus.br/pje-consulta-api/api/processos/",
  httr::content(r_id)[[1]]$id
)

# acessei o captcha
u_captcha <- "https://pje.trt2.jus.br/pje-consulta-api/api/captcha"
r_captcha <- httr::GET(
  u_captcha,
  query = list(idProcesso = httr::content(r_id)[[1]]$id)
)
# salvei o captcha
httr::content(r_captcha)$imagem |>
  base64enc::base64decode() |>
  writeBin("output/captcha.jpeg")

f_captcha <- "output/captcha.jpeg"

modelo <- luz::luz_load("~/Documents/jtrecenti/captcha/data-raw/trt_99.pt")

# label <- captchaDownload:::captcha_label(f_captcha)
label <- captcha::decrypt(f_captcha, modelo)

q_captcha <- list(
  tokenDesafio = httr::content(r_captcha)$tokenDesafio,
  resposta = label
)

r <- httr::GET(
  u_pesquisa, query = q_captcha,
  httr::add_headers("x-grau-instancia" = 1)
)
httr::content(r)

plot(captcha::read_captcha(f_captcha))
