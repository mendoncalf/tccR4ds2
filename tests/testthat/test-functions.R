test_that("plot_atraso works", {
    p = plot_atraso(col = atraso_partida,
                      title = 'partida > 30min',
                      atraso_min = lubridate::make_difftime(60*30))
    expect_type(p, "list")
})

test_that("plot_atraso_serie works", {
  p = plot_atraso_serie(atraso_min = lubridate::make_difftime(60*30))
  expect_type(p, "list")

})

test_that("plot_count works", {
  p = plot_count(col = companhia , title = 'Numero de companhia aéreas operando voos')
  expect_type(p, "list")
})

test_that("destinos_semana works", {
  p = destinos_semana(min_ocorencias = 100, title = "Destinos por dia da semana")
  expect_type(p, "list")

  p = destinos_semana(destinos = c('SFO', 'LAX', 'LAS', 'BOS', 'IAD', 'ORD'),
                  min_ocorencias = 100,title = "Destinos chave por dia da semana")
  expect_type(p, "list")

})

test_that("max_atraso works", {
  expect_s3_class(max_atraso(meus_voos), "tbl")
})

test_that("max_antecipado works", {
  expect_s3_class(max_antecipado(meus_voos), "tbl")
})

test_that("meus_voos works", {
  expect_equal(colnames(meus_voos), c("ano", "mes", "dia", "data", "semana",
                                      "hora_partida", "atraso_partida", "atrasou_partida",
                                      "atraso_chegada", "atrasou_chegada", "companhia",
                                      "origem", "destino", "distancia"))
})

test_that("destinos_semana works", {
  expect_error(destinos_semana_tabela(min_ocorencias = 100))
  expect_error(destinos_semana_tabela(destinos = 'LAX'))

  tab = class(destinos_semana_tabela(destinos = 'LAX', min_ocorencias = 100))
  expect_equal(tab,"knitr_kable")

})

