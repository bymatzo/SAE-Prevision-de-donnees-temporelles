library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)

library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)

# =========================
# GRAPHIQUE DES TRAINS
# =========================

url_train <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/donnees_ligne_A.csv"

train <- read_delim(
  file = url_train,
  delim = ",",
  locale = locale(encoding = "UTF-8"),
  show_col_types = FALSE
)

df_train <- train %>%
  filter(
    Date >= as.Date("2016-01-01"),
    Date <= as.Date("2020-01-01")
  ) %>%
  arrange(Date)

ggplot(df_train, aes(x = Date, y = `Taux de ponctualité`)) +
  geom_line(color = "steelblue") +
  scale_x_date(
    date_breaks = "2 month",
    date_labels = "%m/%Y"
  ) +
  labs(
    title = "Évolution mensuelle du taux de ponctualité (2016–2021)",
    x = "Mois",
    y = "Taux de ponctualité"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# =========================
# GRAPHIQUE DES TRAINS
# =========================

url_train <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/donnees_ligne_A.csv"

train <- read_delim(
  file = url_train,
  delim = ",",
  locale = locale(encoding = "UTF-8"),
  show_col_types = FALSE
)

df_train <- train %>%
  filter(
    Date >= as.Date("2016-01-01"),
    Date <= as.Date("2020-01-01")
  ) %>%
  arrange(Date)

ggplot(df_train, aes(x = Date, y = `Taux de ponctualité`)) +
  geom_line(color = "steelblue") +
  scale_x_date(
    date_breaks = "1 month",
    date_labels = "%m/%Y"
  ) +
  labs(
    title = "Évolution mensuelle du taux de ponctualité (2016–2020)",
    x = "Mois",
    y = "Taux de ponctualité"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# =========================
# GRAPHIQUE NETFLIX
# =========================

url_netflix <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/Données_Clients_Netflix.csv"

netflix <- read_delim(
  file = url_netflix,
  delim = ";",
  show_col_types = FALSE
)

df_netflix <- netflix %>%
  rename(Date = `Time Period`) %>%
  mutate(Date = dmy(Date)) %>%
  arrange(Date)

ggplot(df_netflix, aes(x = Date, y = Subscribers)) +
  geom_line(color = "red") +
  scale_x_date(
    date_breaks = "1 year",
    date_labels = "%Y"
  ) +
  labs(
    title = "Évolution du nombre d'abonnés Netflix",
    x = "Date",
    y = "Nombre d'abonnés"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))