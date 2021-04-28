
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tccR4ds2

<!-- badges: start -->
<!-- badges: end -->

O objetivo desse pacote é servir de repositório para as análises do TCC
do curso de R4DS2 da curso-R, turma de abril de 2021.

## Instalação

``` r
# install.packages("devtools")
devtools::install_github("mendoncalf/tccR4ds2")
```

# Por qual aeroporto devo chegar aos EUA?

Segundo a postagem do site [passageiro de
primeira](https://passageirodeprimeira.com/lista-das-companhias-aereas-que-ainda-estao-voando-entre-os-eua-e-o-brasil/)
os aeroportos nos EUA que mais recebem voos do Brasil são: Miami (MIA),
Orlando (MCO), Nova York (JFK), Atlanta (ATL), Houston (IAH) e Fort
Lauderdale (FLL).

Nesse contexto, nos propomos a analisar quais desses aeroportos seria a
melhor opção para um Brasileiro chegar aos EUA. Ignorando parâmetros de
preço de passagem aérea, e usando as bases de dados do pacote
[`anyflights`](https://github.com/simonpcouch/anyflights), vamos avaliar
a performance desses 6 aeroportos com base em **atrasos**, **número de
companhias aéreas**, **oferta de destinos**, e **conexões com destinos
chave**. Foram considerados apenas os voos do ano de 2019 para a
análise.

## 1 - Atrasos

<br>

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" style="display: block; margin: auto;" />

<br>

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" style="display: block; margin: auto;" />

<br>

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" style="display: block; margin: auto;" />

<br>

## 2 - Número de companhas aéreas

<br>

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" style="display: block; margin: auto;" />

<br>

## 3 - Oferta de destinos

<br>

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" style="display: block; margin: auto;" />

<br>

## 4 - Oferta de destinos especiais

<br>

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" style="display: block; margin: auto;" />

<br>

## Extra - Curiosidade: maiores atrasos e antecipações de cada aeroporto

<br>

| origem | destino | data       | atraso\_partida |
|:-------|:--------|:-----------|----------------:|
| MCO    | DFW     | 2019-03-30 |     1d 5H 2M 0S |
| IAH    | BOS     | 2019-12-02 |    1d 2H 40M 0S |
| JFK    | HNL     | 2019-02-19 |    1d 1H 36M 0S |
| ATL    | IAH     | 2019-02-03 |    1d 0H 20M 0S |
| FLL    | CLT     | 2019-04-14 |      23H 46M 0S |
| MIA    | EWR     | 2019-08-07 |      22H 41M 0S |

<br>

| origem | destino | data       | antecipacao\_partida |
|:-------|:--------|:-----------|---------------------:|
| ATL    | MOB     | 2019-04-11 |              -52M 0S |
| FLL    | DTW     | 2019-09-02 |              -43M 0S |
| MCO    | ATL     | 2019-04-08 |              -30M 0S |
| MIA    | RDU     | 2019-10-10 |              -26M 0S |
| JFK    | BUF     | 2019-01-29 |              -24M 0S |
| JFK    | RIC     | 2019-05-21 |              -24M 0S |
| IAH    | PHL     | 2019-07-20 |              -24M 0S |
