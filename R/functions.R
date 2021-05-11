

#' Funcao para plotagem do atraso percentual medio ao longo do ano
#'
#' Essa funcao calcula o atraso percentual medio de atrasos ao longo do ano, com base em um valor minino de segundos, para os 6 aeroportos da base de dados.
#'
#' @param col uma coluna do tipo `difftime` do dataset `meus_voos`
#' @param title um stirng com o titulo a ser usado pelo grafico
#' @param atraso_min declara o valor minimo em segundos para ser considerado um atraso. Use `lubridate::make_difftime()` para declarar o valor em segundos
#'
#' @return um grafico
#' @export
#'
#' @examples
#' plot_atraso(col = atraso_partida, title = 'partida > 30min',
#'             atraso_min = lubridate::make_difftime(60*30))
plot_atraso = function(col, title, atraso_min){
  tccR4ds2::meus_voos %>%
    dplyr::group_by(.data$origem) %>%
    dplyr::mutate(atraso = {{col}} > atraso_min) %>%
    dplyr::summarise(n_voos = dplyr::n(),
                     n_voos_atraso = sum(.data$atraso)
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(Atraso_perc = .data$n_voos_atraso / .data$n_voos,
    ) %>%
    ggplot2::ggplot()+
    ggplot2::aes(x = forcats::fct_reorder(.data$origem, .data$Atraso_perc, .fun = max),
                 y = .data$Atraso_perc, fill = .data$origem)+
    ggplot2::geom_col()+
    ggplot2::labs(x = 'Aeroportos', y ='%',
                  title = paste0('Porcentagem de voos com atrado na ', title)) +
    ggplot2::theme(plot.title =ggplot2::element_text(hjust = 0.5))+
    ggplot2::theme(legend.title = ggplot2::element_blank())
}


#' Funcao de plotagem do atraso percentual medio ao longo do tempo
#'
#' Essa funcao faz a plotagem do atraso percentual medio ao longo os meses para os 6 aeroportos da base de dados.
#'
#' @param atraso_min declara o valor minimo em segundos para ser considerado um atraso. Use `lubridate::make_difftime()` para declarar o valor em segundos.
#'
#' @return um grafico
#' @export
#'
#' @examples
#' plot_atraso_serie(atraso_min = lubridate::make_difftime(60*30))
plot_atraso_serie <- function(atraso_min) {
  tccR4ds2::meus_voos %>%
    dplyr::mutate(data = lubridate::floor_date(.data$data, unit = 'month')) %>%
    dplyr::group_by(.data$origem, .data$data) %>%
    dplyr::summarise(n_voos = dplyr::n(),
                     n_voos_atraso_partida = sum(.data$atraso_partida > atraso_min),
                     n_voos_atraso_chegada = sum(.data$atraso_chegada > atraso_min)
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(Atraso_partida = .data$n_voos_atraso_partida / .data$n_voos,
                  Atraso_chegada = .data$n_voos_atraso_chegada / .data$n_voos
    ) %>%
    tidyr::pivot_longer(cols = c('Atraso_partida', 'Atraso_chegada'),
                        names_to = 'tipo', values_to = 'atraso') %>%
    dplyr::mutate(tipo = forcats::fct_relevel(.data$tipo, 'Atraso_partida')) %>%
    ggplot2::ggplot()+
    ggplot2::facet_wrap(~.data$tipo)+
    ggplot2::aes(x = .data$data, y = .data$atraso, color = .data$origem)+
    ggplot2::geom_line(size = 1)+ ggplot2::labs(x="", y = "% voos com atraso")+
    ggplot2::theme(legend.title = ggplot2::element_blank())
}


#' Contagem de categorias com base em uma coluna
#'
#' Essa funcao conta a quantidade de nivels existe de uma coluna sempre agrupadas pela coluna `origem` do dataset `meus_voos`.
#'
#' @param col uma coluna categorica do dataset `meus_voos`
#' @param title um stirng com o titulo a ser usado pelo grafico
#'
#' @return um grafico de barras com a contagem
#' @export
#'
#' @examples
#' plot_count(col = companhia , title = 'Numero de companhia aéreas operando voos')
plot_count = function(col, title){
  tccR4ds2::meus_voos %>%
    dplyr::group_by(.data$origem) %>%
    dplyr::summarise(n = dplyr::n_distinct({{col}})) %>%
    ggplot2::ggplot()+
    ggplot2::aes(x = forcats::fct_reorder(.data$origem, .data$n, .fun = max, .desc = TRUE),
                 y = .data$n, fill = .data$origem)+
    ggplot2::geom_col()+
    ggplot2::labs(x = 'Aeroportos', y = 'quantidade', title = paste0(title))+
    ggplot2::theme(plot.title =ggplot2::element_text(hjust = 0.5))+
    ggplot2::theme(legend.title = ggplot2::element_blank())
}


#' Plotagem do numero de destinos de um aeroporto
#'
#' Essa função faz a plotagem do numero de destinos de um aeroporto, divididos por dia da semana e considerando apenas os destinos com um minimo de ocorrencias anual
#'
#' @param destinos vetor de string dos aeroportos de destino de interesse. Use a sigla FAA igual espeficicado no pacote `anyflyghts`. Default = NULL tras todos os destinos
#' @param min_ocorencias numero minimo de ocorrencias para que seja considerado um destino regular.
#' @param title titulo a ser utilizado pelo grafico
#'
#' @return um grafico
#' @export
#'
#' @examples
#' destinos_semana(destinos = c('SFO', 'LAX', 'LAS', 'BOS', 'IAD', 'ORD'),
#'                 min_ocorencias = 100, title = "Destinos clave por dia da semana")
destinos_semana = function(destinos = NULL, min_ocorencias, title){

  if(!is.null(destinos)){
    meus_voos2 = tccR4ds2::meus_voos %>%
      dplyr::filter(.data$destino %in% destinos)
  }else{
    meus_voos2 = tccR4ds2::meus_voos
  }

  meus_voos2 %>%
    dplyr::mutate(diasemana = lubridate::wday(.data$data, label = TRUE)) %>%
    dplyr::group_by(.data$origem, .data$diasemana, .data$destino) %>%
    dplyr::summarise(n = dplyr::n()) %>%
    dplyr::filter(.data$n > min_ocorencias) %>%
    dplyr::group_by(.data$origem, .data$diasemana) %>%
    dplyr::summarise(n = dplyr::n_distinct(.data$destino)) %>%
    ggplot2::ggplot()+
    ggplot2::facet_wrap(~.data$diasemana, ncol = 3)+
    ggplot2::aes(x = forcats::fct_reorder(.data$origem, .data$n, max, .desc = TRUE),
                 y = .data$n, fill = .data$origem)+
    ggplot2::geom_col()+
    ggplot2::labs(x = 'Aeroportos', y = 'Numero de destinos', title = paste0(title),
                  subtitle = paste0('minimo de ',min_ocorencias, ' ocorrencias no ano'))+
    ggplot2::theme(plot.title =ggplot2::element_text(hjust = 0.5),
                   plot.subtitle =ggplot2::element_text(hjust = 0.5))+
    ggplot2::theme(legend.title = ggplot2::element_blank())

}


#' Funcao auxiliar - encontra o voo de maior atraso de partida
#'
#' @param data dataset `meus_voos`
#'
#' @return uma linha do dataset `meus_voos`
#' @export
#'
#' @examples
#' max_atraso(meus_voos)
max_atraso = function(data){
  data %>%
    dplyr::filter(.data$atraso_partida == max(.data$atraso_partida))
}

#' Funcao auxiliar - encontra o voo de maior antecipacao de partida
#'
#' @param data dataset `meus_voos`
#'
#' @return uma linha do dataset `meus_voos`
#' @export
#'
#' @examples
#' max_antecipado(meus_voos)
max_antecipado = function(data){
  data %>%
    dplyr::filter(.data$atraso_partida == min(.data$atraso_partida))
}


#' Tabela de coincidencia origem-destino
#'
#' Produz uma tabela com todas as origem nas linhas e destinos selecionados nas colunas, marcando 'X' se o voo existir.
#'
#' @param destinos vetor de string dos aeroportos de destino de interesse. Use a sigla FAA igual espeficicado no pacote `anyflyghts`. Default = NULL tras todos os destinos
#' @param min_ocorencias numero minimo de ocorrencias para que seja considerado um destino regular.
#'
#' @return uma tabela
#' @export
#'
#' @examples
#' destinos_semana_tabela(destinos = c('SFO', 'LAX'), min_ocorencias = 100)
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
    dplyr::mutate(check = 'ok') %>%
    dplyr::select(-.data$n) %>%
    dplyr::arrange(.data$diasemana) %>%
    tidyr::pivot_wider(names_from = .data$destino, values_from = .data$check) %>%
    dplyr::relocate(.data$diasemana) %>%
    dplyr::mutate(dplyr::across(
      .cols = dplyr::everything(),
      .fns = ~tidyr::replace_na(.x, 'sem voo'))) %>%
    knitr::kable()
}

