## code to prepare `meus_dados` dataset goes here

usethis::use_data(meus_dados, overwrite = TRUE)

library(magrittr)
library(dplyr)
library(anyflights)
library(lubridate)
library(readr)

voos = anyflights::get_flights(c('MIA', 'JFK', 'ATL', 'IAH', 'MCO', 'FLL'), 2019)

aeroportos = anyflights::get_airports('data-raw/')
saveRDS(aeroportos, 'data-raw/aeroportos.rds')

voos = voos %>%
  left_join(aeroportos[,1:2], by = c('origin' = 'faa'))

saveRDS(voos, 'data-raw/voos.rds')

# erro
# get_planes(year = 2019, dir = 'data-raw/')
# get_airlines(dir = 'data-raw/')

# Adicioando empresa e aviao (base dados)
# voos_comp = voos %>%
#             left_join(dados::companhias_aereas, by = c('carrier' = 'companhia_aerea')) %>%
#             left_join(dados::avioes[,c(1,4,5)], by = c('tailnum' = 'codigo_cauda') )

# saveRDS(voos_comp, 'data-raw/voos_comp.rds')

# arrumando base

voos = read_rds('data-raw/voos.rds')

glimpse(voos)

meus_voos = voos %>%
  filter(across(
    .cols = everything(),
    .fns = ~!is.na(.x)
  )) %>%
  dplyr::transmute(ano = year,
                   mes = month,
                   dia = day,
                   data = date(time_hour),
                   semana = week(data),
                   hora_partida = hms::hms(hours(hour)+minutes(minute)),
                   atraso_partida = hms::hms(lubridate::as.period(dep_delay, unit = 'min')),
                   atrasou_partida = dep_delay>0,
                   atraso_chegada = hms::hms(lubridate::as.period(arr_delay , unit = 'min')),
                   atrasou_chegada = arr_delay>0,
                   companhia = carrier,
                   origem = origin,
                   destino = dest,
                   distancia = distance
                   )


glimpse(meus_voos)










