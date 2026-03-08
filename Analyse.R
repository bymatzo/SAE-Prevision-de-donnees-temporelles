library(readr)

url_train <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/Données_Ponctualité_Train_Corrigées.csv"
url_netflix <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/Données_Clients_Netflix.csv"

train <- read_delim(
  file = url_train,
  delim = ";",
  locale = locale(encoding = "latin1")
)

netflix <- read_delim(
  file = url_netflix,
  delim = ";",
  locale = locale(encoding = "UTF-8")
)

head(train)
head(netflix)


