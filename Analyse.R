library(readr)

url_train <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/Données_Ponctualité_Train_Brut.csv"
url_netflix <- "https://raw.githubusercontent.com/bymatzo/SAE-Prevision-de-donnees-temporelles/data/Données_Clients_Netflix.csv"

train <- read_csv(url_train)
netflix <- read_csv(url_netflix)

head(train)
head(netflix)
