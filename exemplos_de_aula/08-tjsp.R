library(tidyverse)
library(httr)
library(rvest)
library(xml2)

# datajud -- quem sabe!!

# enquanto isso

u_tjsp <- "https://esaj.tjsp.jus.br/cjsg/resultadoCompleta.do"

body <- list(
  "conversationId" = "",
  "dados.buscaInteiroTeor" = "lgdp",
  "dados.pesquisarComSinonimos" = "S",
  "dados.pesquisarComSinonimos" = "S",
  "dados.buscaEmenta" = "",
  "dados.nuProcOrigem" = "",
  "dados.nuRegistro" = "",
  "agenteSelectedEntitiesList" = "",
  "contadoragente" = "0",
  "contadorMaioragente" = "0",
  "codigoCr" = "",
  "codigoTr" = "",
  "nmAgente" = "",
  "juizProlatorSelectedEntitiesList" = "",
  "contadorjuizProlator" = "0",
  "contadorMaiorjuizProlator" = "0",
  "codigoJuizCr" = "",
  "codigoJuizTr" = "",
  "nmJuiz" = "",
  "classesTreeSelection.values" = "",
  "classesTreeSelection.text" = "",
  "assuntosTreeSelection.values" = "",
  "assuntosTreeSelection.text" = "",
  "comarcaSelectedEntitiesList" = "",
  "contadorcomarca" = "0",
  "contadorMaiorcomarca" = "0",
  "cdComarca" = "",
  "nmComarca" = "",
  "secoesTreeSelection.values" = "",
  "secoesTreeSelection.text" = "",
  "dados.dtJulgamentoInicio" = "",
  "dados.dtJulgamentoFim" = "",
  "dados.dtPublicacaoInicio" = "",
  "dados.dtPublicacaoFim" = "",
  "dados.origensSelecionadas" = "T",
  "tipoDecisaoSelecionados" = "A",
  "dados.ordenarPor" = "dtPublicacao"
)

## rodar isso aqui se estiver com preguiça de copiar todos os
## parâmetros
# abjutils::chrome_to_body("conversationId:
# dados.buscaInteiroTeor: lgdp
# dados.pesquisarComSinonimos: S
# dados.pesquisarComSinonimos: S
# dados.buscaEmenta:
# dados.nuProcOrigem:
# dados.nuRegistro:
# agenteSelectedEntitiesList:
# contadoragente: 0
# contadorMaioragente: 0
# codigoCr:
# codigoTr:
# nmAgente:
# juizProlatorSelectedEntitiesList:
# contadorjuizProlator: 0
# contadorMaiorjuizProlator: 0
# codigoJuizCr:
# codigoJuizTr:
# nmJuiz:
# classesTreeSelection.values:
# classesTreeSelection.text:
# assuntosTreeSelection.values:
# assuntosTreeSelection.text:
# comarcaSelectedEntitiesList:
# contadorcomarca: 0
# contadorMaiorcomarca: 0
# cdComarca:
# nmComarca:
# secoesTreeSelection.values:
# secoesTreeSelection.text:
# dados.dtJulgamentoInicio:
# dados.dtJulgamentoFim:
# dados.dtPublicacaoInicio:
# dados.dtPublicacaoFim:
# dados.origensSelecionadas: T
# tipoDecisaoSelecionados: A
# dados.ordenarPor: dtPublicacao")


# alternativa com urltools
urltools::param_get("https://google.com/?conversationId=&dados.buscaInteiroTeor=lgdp&dados.pesquisarComSinonimos=S&dados.pesquisarComSinonimos=S&dados.buscaEmenta=&dados.nuProcOrigem=&dados.nuRegistro=&agenteSelectedEntitiesList=&contadoragente=0&contadorMaioragente=0&codigoCr=&codigoTr=&nmAgente=&juizProlatorSelectedEntitiesList=&contadorjuizProlator=0&contadorMaiorjuizProlator=0&codigoJuizCr=&codigoJuizTr=&nmJuiz=&classesTreeSelection.values=&classesTreeSelection.text=&assuntosTreeSelection.values=&assuntosTreeSelection.text=&comarcaSelectedEntitiesList=&contadorcomarca=0&contadorMaiorcomarca=0&cdComarca=&nmComarca=&secoesTreeSelection.values=&secoesTreeSelection.text=&dados.dtJulgamentoInicio=&dados.dtJulgamentoFim=&dados.dtPublicacaoInicio=&dados.dtPublicacaoFim=&dados.origensSelecionadas=T&tipoDecisaoSelecionados=A&dados.ordenarPor=dtPublicacao") |>
  as.list()

r_tjsp <- POST(u_tjsp, body = body)

# muitas vezes, é necessário colocar isso aqui
r_tjsp <- POST(u_tjsp, body = body, encode = "form")


## Isso aqui poderia virar uma função
## dica: funciona para a página 1!
u_pagina <- "https://esaj.tjsp.jus.br/cjsg/trocaDePagina.do"
q_pagina <- list(tipoDeDecisao = "A", pagina = 2, conversationId = "")
r_tjsp_pag <- GET(u_pagina, query = q_pagina, write_disk())

todas_tabelas <- r_tjsp_pag |>
  read_html() |>
  xml_find_all("//tr[@class='fundocinza1']//table")

processar_tabela <- function(tabela) {
  tab_bruta <- tabela |>
    rvest::html_table() |>
    select(X1) |>
    mutate(X1 = str_squish(X1))

  tab_processo <- tibble(
    nome = "Processo",
    valor = str_extract(tab_bruta$X1[1], "^[^ ]+")
  )

  tab_conteudo <- tab_bruta |>
    slice(-1) |>
    separate(
      X1, c("nome", "valor"),
      sep = ": ",
      extra = "merge"
    )

  bind_rows(tab_processo, tab_conteudo) |>
    pivot_wider(names_from = nome, values_from = valor) |>
    janitor::clean_names()

}

base_pagina_2 <- todas_tabelas |>
  map(processar_tabela) |>
  bind_rows()
