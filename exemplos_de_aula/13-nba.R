# WEB DRIVER ------------------------------------------------------

library(webdriver)

pjs <- run_phantomjs()
pjs

ses <- Session$new(port = pjs$port)
ses

ses$go("https://google.com")

ses$takeScreenshot()

busca <- ses$findElement(xpath = "//input[@name='q']")
busca$click()

ses$takeScreenshot()

busca$setValue("linguagem R")

ses$takeScreenshot()

busca$sendKeys(key$enter)

ses$takeScreenshot()

# SELENIUM --------------------------------------------------------

library(RSelenium)

drv <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444L,
  browserName = "chrome"
)

drv$open()

drv$navigate("https://google.com")

elem <- drv$findElement("xpath", "//input[@name='q']")

elem$sendKeysToElement(list("ibovespa", key = "enter"))

Sys.sleep(2)

drv$screenshot(display = TRUE)

drv$close()

# NBA -------------------------------------------------------------

url <- "https://www.nba.com/stats/players/traditional/?sort=PLAYER_NAME&dir=-1&Season=2021-22&SeasonType=Regular%20Season"

library(webdriver)

pjs <- run_phantomjs()
pjs

ses <- Session$new(port = pjs$port)
ses

ses$go(url)

ses$takeScreenshot()

# -----

library(RSelenium)

drv <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4444L,
  browserName = "chrome"
)

drv$open()

drv$navigate(url)

drv$screenshot(file = "tmp.png")

elem <- drv$findElement("xpath", "//button[@id='onetrust-accept-btn-handler']")

elem$clickElement()

drv$screenshot(file = "tmp.png")

tabela_completa <- tibble::tibble()
for (i in 1:12) {

  tabela_completa <- drv$getPageSource() |>
    purrr::pluck(1) |>
    xml2::read_html() |>
    xml2::xml_find_all("//div[@class='nba-stat-table__overflow']/table") |>
    rvest::html_table() |>
    purrr::pluck(1) |>
    dplyr::select(-1) |>
    janitor::clean_names() |>
    dplyr::bind_rows(tabela_completa)

  print(tabela_completa)
  Sys.sleep(2)

  elem <- drv$findElement("xpath", "//a[@class='stats-table-pagination__next']")

  elem$clickElement()

  Sys.sleep(2)
}

drv$screenshot(file = "tmp.png")

drv$close()

dplyr::glimpse(tabela_completa)
