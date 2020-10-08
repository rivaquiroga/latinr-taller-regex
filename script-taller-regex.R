## LatinR 2020
## Expresiones regulares para la limpieza y transformación de datos
## Taller a cargo de Riva Quiroga (@rivaquiroga) y Stephanie Orellana (@sporella)
## 

# Parte 1 -----------------------------------------------------------------


library(tidyverse)
library(datos)

# Posibilidades que existen con función filter()
# 

paises
View(paises)

paises %>% 
  filter(pais == "México")

paises %>% 
  filter(pais == "Corea")

paises %>% 
  filter(str_detect(pais, "Corea")) %>% 
  count(pais)

paises %>% 
  filter(str_detect(pais, "Per"))

paises %>% 
  filter(str_detect(pais, "M[e|é]xico"))

telefonos <- read_csv("https://raw.githubusercontent.com/rivaquiroga/latinr-taller-regex/master/datos/telefonos.csv")

head(telefonos)

# Miremos primero la ciudad

telefonos %>% 
  count(ciudad)

telefonos %>% 
  filter(str_detect(ciudad, "quilpu[e|é]"))

# Miremos qué pasa cuando saco []
telefonos %>% 
  filter(str_detect(ciudad, "quilpue|é"))

# Ahora para Valparaíso

telefonos %>% 
  filter(str_detect(ciudad, "[V|v]alpara[i|í]so"))

# case_when()

telefonos %>%
  mutate(ciudad = case_when(
    str_detect(ciudad, "[V|v]alpara[i|í]so") ~ "Valparaíso",
    TRUE ~ as.character(ciudad)
  ))

# En una nueva columna

telefonos %>%
  mutate(ciudad_limpia = case_when(
    str_detect(ciudad, "[V|v]alpara[i|í]so") ~ "Valparaíso",
    TRUE ~ as.character(ciudad)
  ))


# Ahora con quilpué

telefonos %>%
  mutate(ciudad_limpia = case_when(
    str_detect(ciudad, "[V|v]alpara[i|í]so") ~ "Valparaíso",
    str_detect(ciudad, "quilpu[e|é]") ~ "Quilpué",
    TRUE ~ as.character(ciudad)
  ))

# Ahora con La Serena

telefonos %>%
  mutate(ciudad_limpia = case_when(
    str_detect(ciudad, "[V|v]alpara[i|í]so") ~ "Valparaíso",
    str_detect(ciudad, "quilpu[e|é]") ~ "Quilpué",
    str_detect(ciudad, "Serena") ~ "La Serena",
    TRUE ~ as.character(ciudad)
  ))

telefonos <- telefonos %>%
  mutate(ciudad_limpia = case_when(
    str_detect(ciudad, "[V|v]alpara[i|í]so") ~ "Valparaíso",
    str_detect(ciudad, "quilpu[e|é]") ~ "Quilpué",
    str_detect(ciudad, "Serena") ~ "La Serena",
    TRUE ~ as.character(ciudad)
  ))

telefonos %>% 
  count(ciudad_limpia)

# Parte 2 -----------------------------------------------------------------

# datos -------------------------------------------------------------------
peliculas <- read_csv("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2020/2020-02-19/ranking_imdb.csv")
pinguinos <- datos::pinguinos
animales <- read_csv("https://raw.githubusercontent.com/rivaquiroga/latinr-taller-regex/master/datos/animales.csv")

# separate() --------------------------------------------------------------

pelis_sep <- peliculas %>% 
  separate(genero, into = c("genero_principal","genero_secundario"),
           sep = ", ", remove = FALSE, extra = "merge")

# separate_rows() ---------------------------------------------------------

pelis_row <- peliculas %>% 
  separate_rows(genero, sep = ", ")

pelis_row2 <- peliculas %>% 
  separate_rows(genero)

# pivot_longer() ----------------------------------------------------------

pinguinos <- datos::pinguinos

pinguinos_L1<- pinguinos %>% 
  pivot_longer(largo_pico_mm:masa_corporal_g)

pinguinos_L2<- pinguinos %>% 
  pivot_longer(largo_pico_mm:masa_corporal_g, 
               names_pattern = "(.*_.*)_(.*)", 
               names_to = c("variable", "unidad"))

# 
animales <- read_csv("https://raw.githubusercontent.com/rivaquiroga/latinr-taller-regex/master/datos/animales.csv")

animales_limpio <- animales %>%
  pivot_longer(
    starts_with("s"),
    names_pattern = "(.*)_monitoreo(.*)_(.*)",
    names_to = c("sitio", "annio", "mes")
  ) %>%
  separate_rows(value)
