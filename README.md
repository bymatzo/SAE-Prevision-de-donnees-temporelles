# README — Prevision de Donnees Temporelles
## Guide complet pour l'oral

---

## Table des matieres

1. [Contexte du projet](#1-contexte-du-projet)
2. [Les donnees](#2-les-donnees)
3. [Concepts fondamentaux](#3-concepts-fondamentaux)
4. [Methodologie etape par etape](#4-methodologie-etape-par-etape)
5. [Resultats Netflix](#5-resultats-netflix)
6. [Resultats RER A](#6-resultats-rer-a)
7. [Conclusion generale](#7-conclusion-generale)
8. [Questions pieges et reponses](#8-questions-pieges-et-reponses)

---

## 1. Contexte du projet

Ce projet analyse deux series temporelles avec des caracteristiques differentes afin de choisir et valider le modele de prevision le plus adapte a chacune.

| | Netflix | RER A |
|---|---|---|
| **Nature** | Abonnes trimestriels | Taux de ponctualite mensuel |
| **Periode** | Pluriannuelle | 2016 - 2020 |
| **Tendance** | Forte hausse | Legere baisse |
| **Saisonnalite** | Absente | Annuelle (12 mois) |
| **Modele choisi** | Additif | Additif |
| **Modele de reference** | Moyennes sur le passe | Moyennes mobiles k=12 |
| **Modele retenu** | Holt (lissage double) | Holt-Winters (lissage triple) |

---

## 2. Les donnees

### Netflix
- **Source** : Kaggle / GitHub projet
- **Variable** : `Subscribers` — nombre d'abonnes en valeur absolue
- **Frequence** : trimestrielle (4 observations par an)
- **Caracteristique cle** : croissance quasi-lineaire et soutenue, sans pattern saisonnier identifiable

### RER A
- **Source** : RATP
- **Variable** : `Taux de ponctualite` — proportion de trains a l'heure (entre 0 et 1)
- **Frequence** : mensuelle (12 observations par an)
- **Caracteristique cle** : tendance legere a la baisse avec une saisonnalite annuelle marquee (mauvais hivers, bons etes)

---

## 3. Concepts fondamentaux

### Qu'est-ce qu'une serie temporelle ?
Une serie temporelle est une suite de valeurs mesurees a intervalles reguliers dans le temps. Elle se decompose generalement en trois composantes :
- **Tendance** : direction generale sur le long terme (hausse, baisse, stagnation)
- **Saisonnalite** : pattern periodique qui se repete a intervalles fixes (chaque annee, chaque trimestre...)
- **Residu** : ce qui reste apres avoir retire tendance et saisonnalite — le "bruit" non explique

### Modele additif vs multiplicatif

**Modele additif** :
> Serie = Tendance + Saisonnalite + Residu

On choisit ce modele quand l'amplitude des oscillations saisonnières reste **constante** au fil du temps, independamment du niveau de la serie.

**Modele multiplicatif** :
> Serie = Tendance x Saisonnalite x Residu

On choisit ce modele quand les oscillations saisonnières **grandissent proportionnellement** au niveau de la serie.

**Comment choisir en pratique ?** On regarde la serie brute visuellement. Si les vagues hautes et basses gardent la meme hauteur → additif. Si elles s'ecartent de plus en plus → multiplicatif.

Pour le **RER A** : les ecarts entre bons et mauvais mois restent stables → **additif**.
Pour **Netflix** : la croissance s'emballe mais les variations trimestrielles restent faibles et relativement stables → **additif** egalement (pas de vraie saisonnalite a modeliser).

### Le RMSE — Root Mean Square Error
C'est l'indicateur qui permet de comparer les modeles entre eux.

> RMSE = racine( moyenne( (valeur_reelle - valeur_prevue)^2 ) )

- Il est exprime dans la **meme unite** que la variable (abonnes pour Netflix, taux pour le RER)
- Plus il est **petit**, meilleur est le modele
- Il **penalise davantage les grosses erreurs** car on met les ecarts au carre
- Pour Netflix : un RMSE de 3M signifie que le modele se trompe en moyenne de 3 millions d'abonnes
- Pour le RER : un RMSE de 0.02 signifie une erreur moyenne de 0.02 point de taux de ponctualite

---

## 4. Methodologie etape par etape

La trame suivie pour les deux series est identique et repond exactement aux criteres du sujet :

### Etape 1 — Presentation et contextualisation
- Source des donnees, periode, variable, unite
- Graphique de la serie brute pour identifier visuellement tendance et saisonnalite eventuelle

### Etape 2 — Decomposition de la serie
- Choix du modele (additif ou multiplicatif) justifie visuellement
- Decomposition par moyennes mobiles pour obtenir les 4 composantes : observed, trend, seasonal, random
- Calcul et commentaire des **coefficients saisonniers** (RER uniquement)
- Presentation de la **serie CVS** (Corrigee des Variations Saisonnieres)

### Etape 3 — Validation du modele — analyse des residus
- Les residus doivent etre centres autour de 0 et sans structure
- Les points au-dela de ±2 ecarts-types sont des **valeurs mal ajustees**
- Ces points correspondent a des evenements exceptionnels non previsibles

### Etape 4 — Prevision a court terme
- Deux modeles testes et compares via le RMSE
- Le modele avec le RMSE le plus bas est retenu

---

## 5. Resultats Netflix

### Decomposition
Pas de saisonnalite identifiable. La serie presente uniquement une forte tendance haussiere. Le modele additif est choisi par defaut (pas d'effet multiplicatif visible).

### Modele 1 — Moyennes sur le passe (reference naive)
**Principe** : chaque prevision est la moyenne de toutes les valeurs precedentes.

> Prevision(t+1) = (y1 + y2 + ... + yt) / t

**Probleme** : cette methode converge vers une valeur fixe et ne capte pas du tout la tendance croissante. Elle sous-estime systematiquement les valeurs futures. C'est intentionnellement le "mauvais" modele de reference qui permet de montrer que Holt fait mieux.

**RMSE** : eleve car les previsions restent bloquees a la moyenne historique pendant que les vrais abonnes continuent de grimper.

### Modele 2 — Lissage exponentiel double de Holt (retenu)
**Principe** : lisse simultanement deux composantes :
- **Le niveau** (alpha) : la valeur actuelle de la serie
- **La tendance** (beta) : la pente actuelle de la serie

A chaque nouvelle observation, le modele met a jour ces deux composantes en donnant plus de poids aux observations recentes (d'ou "exponentiel" : les poids decroissent exponentiellement vers le passe).

**Formules** :
> Niveau(t) = alpha x y(t) + (1 - alpha) x (Niveau(t-1) + Tendance(t-1))
> Tendance(t) = beta x (Niveau(t) - Niveau(t-1)) + (1 - beta) x Tendance(t-1)
> Prevision(t+h) = Niveau(t) + h x Tendance(t)

**Pourquoi c'est adapte a Netflix** : la serie a une tendance forte et pas de saisonnalite. Holt est exactement concu pour ce cas. Il s'adapte aux changements de rythme de croissance grace aux parametres alpha et beta.

**RMSE** : nettement inferieur a la methode naive → modele retenu.

### Analyse des residus Holt
Les residus sont globalement proches de zero. Les points aberrants (au-dela de ±2 sigma) correspondent a des accelerations exceptionnelles comme la periode COVID 2020 qui a propulse les abonnements au-dela de ce que la tendance prevoyait.

---

## 6. Resultats RER A

### Decomposition par Moyennes Mobiles

**Comment ca marche — les 3 etapes :**

**Etape 1 : Calcul de la tendance**

On calcule une moyenne mobile d'ordre 12 : pour chaque mois, on fait la moyenne des 12 mois autour de lui (6 avant, 6 apres). Cela lisse mecaniquement la saisonnalite car on inclut exactement une annee complete.

> Tendance(juillet 2017) = moyenne(janvier 2017 a decembre 2017)

Consequence : les 6 premiers et 6 derniers mois n'ont pas de tendance calculee → trous aux extremites du graphique.

**Etape 2 : Calcul de la saisonnalite**

On soustrait la tendance de la serie brute, puis pour chaque mois on fait la moyenne sur toutes les annees :

> Coeff saisonnier(janvier) = moyenne de tous les (janvier brut - tendance janvier)

**Contrainte** : la somme des 12 coefficients = 0 (les effets positifs et negatifs se compensent sur une annee).

**Etape 3 : Calcul des residus**

> Residu = Serie brute - Tendance - Saisonnalite

### Coefficients saisonniers — comment les commenter

**Mois defavorables (coefficients negatifs, barres rouges)** :
Les mois d'automne-hiver (novembre, decembre, janvier) presentent des coefficients negatifs. La ponctualite est systematiquement en dessous de la tendance durant ces periodes. Cela s'explique par les conditions meteorologiques, les mouvements sociaux concentres en fin d'annee, et la surcharge du reseau pendant les periodes de fetes.

**Mois favorables (coefficients positifs, barres vertes)** :
Les mois de printemps-ete (mai, juin, aout) affichent des coefficients positifs. La ponctualite depasse la tendance grace a une frequentation reduite notamment pendant les vacances scolaires.

**Contrainte mathematique** :
La somme des 12 coefficients est exactement egale a zero — propriete fondamentale du modele additif.

### Serie CVS — Corrigee des Variations Saisonnieres

> CVS = Serie brute - Coefficients saisonniers

**A quoi ca sert** :
- Comparer des mois entre eux sans biais saisonnier (decembre vs juin devient pertinent)
- Voir la vraie tendance sans le bruit des oscillations regulieres
- Detecter des anomalies reelles : si la CVS chute en juin (normalement bon mois), c'est qu'un evenement exceptionnel a eu lieu

**Difference CVS vs Tendance** :
- Tendance = uniquement la direction generale lissee
- CVS = Tendance + Residus (contient encore les evenements exceptionnels)

### Analyse des residus
Les residus oscillent autour de 0. Les points au-dela de ±2 ecarts-types indiquent des valeurs mal ajustees par le modele — typiquement des greves ou incidents graves qui ne font pas partie du pattern saisonnier habituel.

### Modele 1 — Prevision par Moyennes Mobiles k=12 (reference)
**Principe** : on predit les valeurs futures en faisant la moyenne des 12 derniers mois connus, puis on rajoute le coefficient saisonnier correspondant au mois prevu.

> Prevision(mois M) = moyenne des 12 derniers mois + coeff saisonnier(M)

C'est une methode simple qui capture la saisonnalite mais qui ne s'adapte pas aux changements de tendance recents. Elle donne un poids egal a tous les 12 derniers mois.

**Limite** : elle reagit lentement aux changements car elle traite toutes les observations passees de la meme facon.

### Modele 2 — Lissage exponentiel triple de Holt-Winters (retenu)
**Principe** : extension de Holt qui lisse trois composantes simultanement :
- **Le niveau** (alpha) : valeur actuelle
- **La tendance** (beta) : pente actuelle
- **La saisonnalite** (gamma) : coefficients saisonniers mis a jour dynamiquement

**Avantage cle sur les moyennes mobiles** : Holt-Winters donne plus de poids aux observations recentes grace aux parametres alpha, beta, gamma optimises automatiquement. Il s'adapte si la saisonnalite ou la tendance evolue au fil du temps, contrairement a la moyenne mobile qui utilise des poids uniformes.

**RMSE** : inferieur a celui des moyennes mobiles → modele retenu.

---

## 7. Conclusion generale

| Critere | Netflix | RER A |
|---|---|---|
| Tendance | Forte hausse | Legere baisse |
| Saisonnalite | Absente | Annuelle (12 mois) |
| Modele de decomposition | Additif | Additif (Moyennes Mobiles ord. 12) |
| Modele de reference | Moyennes sur le passe | Moyennes Mobiles predictives k=12 |
| Modele retenu | **Holt (lissage double)** | **Holt-Winters (lissage triple)** |
| Justification | Tendance sans saisonnalite | Tendance + saisonnalite |

**Message cle** : le choix du modele depend directement de la structure de la serie. La presence ou l'absence de saisonnalite est le critere determinant : Holt suffit quand il n'y a que de la tendance, Holt-Winters est necessaire des qu'une saisonnalite existe. Dans les deux cas le RMSE confirme quantitativement que le modele choisi performe mieux que la reference naive.

---

## 8. Questions pieges et reponses

### Sur la methodologie generale

**Q : Pourquoi utiliser des series temporelles plutot qu'une regression classique ?**
R : La regression classique suppose que les observations sont independantes. Dans une serie temporelle, chaque valeur est liee aux precedentes (autocorrelation). Les modeles de series temporelles exploitent cette dependance pour prevoir, ce qu'une regression ignore.

**Q : Comment validez-vous que votre modele est bon ?**
R : Via deux approches complementaires. D'abord le RMSE qui mesure l'erreur moyenne de prevision — plus petit = meilleur. Ensuite l'analyse des residus : s'ils sont aleatoires, centres sur zero et sans structure, le modele a bien capture toute l'information de la serie.

**Q : Que signifie "court terme" dans vos previsions ?**
R : Pour le RER on predit 12 mois en avant, pour Netflix 8 trimestres (2 ans). Au-dela, l'incertitude devient trop grande et les intervalles de confiance s'elargissent considerablement.

### Sur la decomposition

**Q : Pourquoi ordre 12 pour les moyennes mobiles du RER ?**
R : Car les donnees sont mensuelles avec une saisonnalite annuelle. En faisant la moyenne sur exactement 12 mois consecutifs, on inclut chaque mois de l'annee une fois, ce qui annule mecaniquement la saisonnalite. Si les donnees etaient trimestrielles on utiliserait l'ordre 4.

**Q : Pourquoi y a-t-il des trous au debut et a la fin de la tendance ?**
R : La moyenne mobile d'ordre 12 necessite 6 valeurs avant et 6 apres chaque point. Les 6 premiers et 6 derniers mois de la serie n'ont donc pas assez de voisins pour calculer la tendance → valeurs manquantes aux extremites.

**Q : La somme des coefficients saisonniers vaut combien ?**
R : Zero exactement. Dans un modele additif, les effets positifs (bons mois) et negatifs (mauvais mois) se compensent obligatoirement sur une annee complete.

**Q : Que faire si les residus montrent encore un pattern ?**
R : Cela signifie que le modele est mal specifie et n'a pas capture toute l'information. On peut essayer un modele multiplicatif, augmenter l'ordre de la moyenne mobile, ou envisager d'autres modeles comme ARIMA/SARIMA.

### Sur les modeles de prevision

**Q : C'est quoi la difference entre lissage simple, double et triple ?**
R : Le lissage simple (un seul parametre alpha) ne convient qu'aux series sans tendance ni saisonnalite. Le lissage double de Holt (alpha + beta) ajoute la tendance. Le lissage triple de Holt-Winters (alpha + beta + gamma) ajoute en plus la saisonnalite. On ajoute une composante a chaque fois qu'on detecte un nouvel element dans la serie.

**Q : Que signifient les parametres alpha, beta, gamma ?**
R : Ils controlent la vitesse d'adaptation du modele. Un alpha proche de 1 donne beaucoup de poids aux observations recentes (modele tres reactif). Un alpha proche de 0 donne plus de poids au passe (modele plus lisse). Ces parametres sont optimises automatiquement par R pour minimiser l'erreur sur les donnees historiques.

**Q : Pourquoi Holt-Winters est meilleur que les moyennes mobiles pour le RER ?**
R : Les moyennes mobiles donnent un poids egal aux 12 derniers mois. Holt-Winters donne plus de poids aux observations recentes et met a jour dynamiquement les coefficients saisonniers. Si la saisonnalite ou la tendance evolue, Holt-Winters s'adapte alors que la moyenne mobile reagit beaucoup plus lentement.

**Q : Pourquoi les previsions s'eloignent-elles de la serie avec le temps ?**
R : C'est normal et attendu. Plus on predit loin dans le futur, plus l'incertitude s'accumule. C'est representé par les intervalles de confiance (zone coloree autour de la prevision) qui s'elargissent avec l'horizon de prevision.

**Q : Pourquoi la methode des moyennes sur le passe est-elle mauvaise pour Netflix ?**
R : Parce qu'elle predit une valeur fixe (la moyenne de tout le passe) alors que Netflix est en croissance constante. Elle ne capte pas du tout la tendance et sous-estime systematiquement les valeurs futures. Son RMSE tres eleve le confirme. Elle sert uniquement de reference naive pour montrer que Holt fait nettement mieux.

### Sur la CVS

**Q : Quelle est la difference entre CVS et tendance ?**
R : La tendance est uniquement la direction generale lissee, sans aucune variabilite residuelle. La CVS est la serie brute dont on a retire la saisonnalite, mais elle contient encore les residus (evenements exceptionnels). CVS = Tendance + Residus, alors que Tendance = seulement la composante lisse.

**Q : Pourquoi corriger des variations saisonnieres ?**
R : Pour pouvoir faire des comparaisons pertinentes entre mois differents. Sans CVS, comparer decembre et juin n'a pas de sens car on sait que decembre est structurellement mauvais. Avec la CVS, si decembre est bas, c'est vraiment qu'il s'est passe quelque chose d'anormal, pas juste l'effet habituel de l'hiver.
