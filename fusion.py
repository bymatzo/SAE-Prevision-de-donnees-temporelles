import pandas as pd

df = pd.read_csv("ton_fichier.csv")

df["Date"] = pd.to_datetime(df["Date"], format="%Y-%m")

df_mensuel = (
    df
    .groupby("Date", as_index=False)
    .agg({
        "Taux de ponctualité": "mean",
        "Nombre de voyageurs à l'heure pour un voyageur en retard": "mean"
    })
)

df_mensuel["Taux de ponctualité"] = df_mensuel["Taux de ponctualité"].round(2)
df_mensuel["Nombre de voyageurs à l'heure pour un voyageur en retard"] = (
    df_mensuel["Nombre de voyageurs à l'heure pour un voyageur en retard"].round(0)
)

df_mensuel.to_csv("donnees_mensuelles_agregees.csv", index=False)
