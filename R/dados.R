#' Meus voos
#'
#' Subset da base  do pacote anyflights, somente com os voos do ano de 2019 com origem nos aeroportos de MIA, JFK, ATL, FLL, IAH e MCO
#'
#' @format Uma dataframe com 1018199 linhas e 14 variavies:
#' \describe{
#'   \item{ano}{ano do voo}
#'   \item{mes}{mes do voo}
#'   \item{dia}{dia do voo}
#'   \item{data}{data do voo}
#'   \item{semana}{semana do voo}
#'   \item{hora_partida}{horario de partida do voo}
#'   \item{atraso_partida}{diferenca de entre entre a saida real e a saida programanda}
#'   \item{atrasou_partida}{indica se houve ou não atraso na partida}
#'   \item{atraso_chegada}{diferenca de entre entre a chegada real e a chegada programanda}
#'   \item{atrasou_chegada}{indica se houve ou não atraso na chegada}
#'   \item{companhia}{empresa aerea que opera o voo}
#'   \item{origem}{aeroporto de origem}
#'   \item{destino}{aeroporto de destino}
#'   \item{distancia}{distancia entre origem e destino}
#' }
#' @source \url{https://github.com/simonpcouch/anyflights}
"meus_voos"
