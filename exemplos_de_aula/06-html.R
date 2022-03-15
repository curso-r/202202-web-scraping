# library(XML)

library(xml2)
# library(rvest) # httr + xml2

html <- read_html("exemplos_de_aula/html_exemplo.html")

xml_find_all(html, xpath = "//p")
xml_find_all(html, xpath = "/html/body/p")

# isso funciona para pegar o primeiro elemento
p <- xml_find_first(html, xpath = "//p")

# e o segundo?
# TODO explicar melhor depois
xml_find_all(html, xpath = "/html/body/p[1]")

# explicação!
xml_find_all(html, xpath = "(//p)[3]")




# xml_find_all(html, xpath = "/html/body/p[[1]]")
xml_find_all(html, xpath = "//p[@style='color: blue;']")

nodes <- xml_find_all(html, xpath = "//p")

xml_text(nodes)

xml_attr(nodes, "style")

xml_find_all(html, xpath = "//a") |>
  xml_attr("href")

# todas as tags
xml_attrs(nodes)


xml_children(p)
xml_parents(p)
xml_siblings(p)


xml_parent(p) |>
  xml_siblings()

rvest::html_elements()


# duckduck ----------------------------------------------------------------

r <- httr::GET("https://duckduckgo.com")
r

meu_xpath <- '//*[@id="search_form_input_homepage"]'
meu_xpath_v2 <- '//input[@name="q"]'
r |>
  read_html() |>
  xml_find_all(meu_xpath)

r |>
  read_html() |>
  xml_find_all(meu_xpath_v2)
