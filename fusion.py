import pandas as pd

# Lecture correcte du CSV français
df = pd.read_csv(
    r"C:\Users\mbouvier\Documents\SAE-Proba\ponctualite-mensuelle-transilien.csv",
    sep=";",
    decimal=","
)

# Nettoyage des noms de colonnes
df.columns = df.columns.str.strip()

# Conversion de la date
df["Date"] = pd.to_datetime(df["Date"], format="%Y-%m")

# Agrégation mensuelle
df_mensuel = (
    df
    .groupby("Date", as_index=False)
    .agg({
        "Taux de ponctualité": "mean",
        "Nombre de voyageurs à l'heure pour un voyageur en retard": "mean"
    })
)

# Sauvegarde
df_mensuel.to_csv("donnees_mensuelles_agregees.csv", index=False)
