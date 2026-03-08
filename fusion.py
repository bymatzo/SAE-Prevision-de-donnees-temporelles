import pandas as pd

# Lecture du CSV français
df = pd.read_csv(
    r"C:\Users\darta\Downloads\ponctualite-mensuelle-transilien.csv",
    sep=";",
    decimal=","gu
)

# Nettoyage des noms de colonnes
df.columns = df.columns.str.strip()

# Conversion de la colonne Date
df["Date"] = pd.to_datetime(df["Date"], format="%Y-%m")

# Filtrer uniquement la ligne A
df_ligne_A = df[df["Ligne"] == "A"]

# Garder seulement les colonnes Date et Taux de ponctualité
df_final = df_ligne_A[["Date", "Taux de ponctualité"]]

# Export CSV
df_final.to_csv("donnees_ligne_A.csv", index=False)