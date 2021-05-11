
# vignets / atualizar site
# testthat/ rcov/ actions

devtools::load_all()
library(magrittr, include.only = '%>%')

# Atraso
# plot_atraso = function(col, title, atraso_min){
#   tccR4ds2::meus_voos %>%
#     dplyr::group_by(origem) %>%
#     dplyr::mutate(atraso = {{col}} > atraso_min) %>%
#     dplyr::summarise(n_voos = dplyr::n(),
#                      n_voos_atraso = sum(atraso)
#     ) %>%
#     dplyr::rowwise() %>%
#     dplyr::mutate(Atraso_perc = n_voos_atraso / n_voos,
#     ) %>%
#     ggplot2::ggplot()+
#     ggplot2::aes(x = forcats::fct_reorder(origem, Atraso_perc, .fun = max),
#                  y = Atraso_perc, fill = origem)+
#     ggplot2::geom_col()+
#     ggplot2::labs(x = 'aeroportos', y ='%',
#                   title = paste0('Porcentagem de voos com atrado na ', title)) +
#     ggplot2::theme(plot.title =ggplot2::element_text(hjust = 0.5))+
#     ggplot2::theme(legend.title = ggplot2::element_blank())
# }

plot_atraso(col = atraso_partida,
            title = 'partida > 30min',
            atraso_min = lubridate::make_difftime(60*30))

plot_atraso(col = atraso_chegada,
            title = 'chegada > 30min',
            atraso_min = lubridate::make_difftime(60*30))


# plot_atraso_serie <- function(atraso_min) {
#   tccR4ds2::meus_voos %>%
#     dplyr::mutate(data = lubridate::floor_date(data, unit = 'month')) %>%
#     dplyr::group_by(origem, data) %>%
#     dplyr::summarise(n_voos = dplyr::n(),
#                      n_voos_atraso_partida = sum(atraso_partida > atraso_min),
#                      n_voos_atraso_chegada = sum(atraso_chegada > atraso_min)
#     ) %>%
#     dplyr::rowwise() %>%
#     dplyr::mutate(Atraso_partida = n_voos_atraso_partida / n_voos,
#                   Atraso_chegada = n_voos_atraso_chegada / n_voos
#     ) %>%
#     tidyr::pivot_longer(cols = c('Atraso_partida', 'Atraso_chegada'),
#                         names_to = 'tipo', values_to = 'atraso') %>%
#     dplyr::mutate(tipo = forcats::fct_relevel(tipo, 'Atraso_partida')) %>%
#     ggplot2::ggplot()+
#     ggplot2::facet_wrap(~tipo)+
#     ggplot2::aes(x = data, y = atraso, color = origem)+
#     ggplot2::geom_line(size = 1)+
#     ggplot2::theme(legend.title = ggplot2::element_blank())
# }

plot_atraso_serie(atraso_min = lubridate::make_difftime(60*30))

#### Variedade de Companias
# plot_count = function(col, title){
#   tccR4ds2::meus_voos %>%
#     dplyr::group_by(origem) %>%
#     dplyr::summarise(n = dplyr::n_distinct({{col}})) %>%
#     ggplot2::ggplot()+
#     ggplot2::aes(x = forcats::fct_reorder(origem, n, .fun = max, .desc = TRUE),
#                  y = n, fill = origem)+
#     ggplot2::geom_col()+
#     ggplot2::labs(x = 'aeroportos', y = 'quantidade', title = paste0(title))+
#     ggplot2::theme(plot.title =ggplot2::element_text(hjust = 0.5))+
#     ggplot2::theme(legend.title = ggplot2::element_blank())
# }

plot_count(col = companhia , title = 'Numero de companhia aéreas operando voos')

# Destinos
# destinos_semana = function(destinos = NULL, min_ocorencias, title){
#
#   if(!is.null(destinos)){
#     meus_voos2 = tccR4ds2::meus_voos %>%
#     dplyr::filter(destino %in% destinos)
#     }
#   else{
#     meus_voos2 = tccR4ds2::meus_voos
#     }
#
#   meus_voos2 %>%
#     dplyr::mutate(diasemana = lubridate::wday(data, label = TRUE)) %>%
#     dplyr::group_by(origem, diasemana, destino) %>%
#     dplyr::summarise(n = dplyr::n()) %>%
#     dplyr::filter(n > min_ocorencias) %>%
#     dplyr::group_by(origem, diasemana) %>%
#     dplyr::summarise(n = dplyr::n_distinct(destino)) %>%
#     ggplot2::ggplot()+
#     ggplot2::facet_wrap(~diasemana, ncol = 3)+
#     ggplot2::aes(x = forcats::fct_reorder(origem, n, max, .desc = TRUE), y = n, fill = origem)+
#     ggplot2::geom_col()+
#     ggplot2::labs(x = 'Dia da semana', y = 'Numero de destinos', title = paste0(title),
#                   subtitle = paste0('minimo de ',min_ocorencias, ' ocorrencias no ano'))+
#     ggplot2::theme(plot.title =ggplot2::element_text(hjust = 0.5),
#                    plot.subtitle =ggplot2::element_text(hjust = 0.5))+
#     ggplot2::theme(legend.title = ggplot2::element_blank())
#
# }

destinos_semana(min_ocorencias = 100, title = "Destinos por dia da semana")

destinos_semana(destinos = c('SFO', 'LAX', 'LAS', 'BOS', 'IAD', 'ORD'),
                             min_ocorencias = 100,title = "Destinos clave por dia da semana")


# extra - maiores atrasos/antecipaçoes em cada de cada aeroporto

# max_atraso = function(data){
#   data %>%
#     dplyr::filter(atraso_partida == max(atraso_partida))
# }
#
# max_antecipado = function(data){
#   data %>%
#     dplyr::filter(atraso_partida == min(atraso_partida))
# }

meus_voos %>%
  dplyr::group_by(origem) %>%
  tidyr::nest() %>%
  dplyr::mutate(maximo_atraso = purrr::map(data ,max_antecipado)) %>%
  dplyr::select(origem, maximo_atraso) %>%
  tidyr::unnest(cols = c(maximo_atraso)) %>%
  dplyr::mutate(atraso_partida = lubridate::seconds_to_period(atraso_partida)) %>%
  dplyr::select(origem, destino, data,atraso_partida) %>%
  dplyr::arrange(desc(atraso_partida)) %>%
  knitr::kable()

meus_voos %>%
  dplyr::group_by(origem) %>%
  tidyr::nest() %>%
  dplyr::mutate(maximo_atraso = purrr::map(data ,max_atraso)) %>%
  dplyr::select(origem, maximo_atraso) %>%
  tidyr::unnest(cols = c(maximo_atraso)) %>%
  dplyr::mutate(atraso_partida = lubridate::seconds_to_period(atraso_partida)) %>%
  dplyr::select(origem, destino, data,atraso_partida) %>%
  dplyr::arrange(desc(atraso_partida)) %>%
  knitr::kable()


#### tabela dupla entrada

# destinos = c('SFO', 'LAX', 'LAS', 'BOS', 'IAD', 'ORD')
# min_ocorencias = 100

destinos_semana_tabela = function(destinos = NULL, min_ocorencias = NULL){

  if(is.null(destinos)){stop("destinos must be declared")}
  if(is.null(min_ocorencias)){stop("min_ocorencias must be declared")}

  meus_voos2 = tccR4ds2::meus_voos %>%
    dplyr::filter(.data$destino %in% destinos)

  meus_voos2 %>%
    dplyr::mutate(diasemana = lubridate::wday(.data$data, label = TRUE)) %>%
    dplyr::group_by(.data$origem, .data$diasemana, .data$destino) %>%
    dplyr::summarise(n = dplyr::n()) %>%
    dplyr::filter(.data$n > min_ocorencias)%>%
    dplyr::mutate(check = 'X') %>%
    dplyr::select(-n, -diasemana) %>%
    dplyr::arrange(diasemana) %>%
    tidyr::pivot_wider(names_from = destino, values_from = check) %>%
    dplyr::mutate(dplyr::across(
        .cols = dplyr::everything(),
        .fns = ~tidyr::replace_na(.x, 'sem voo'))) %>%
    knitr::kable()
}

destinos_semana_tabela(destinos = c('SFO', 'LAX', 'LAS', 'BOS', 'IAD', 'ORD'), min_ocorencias = 100)



