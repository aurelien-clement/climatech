


[![image](assets/logo-blue.svg)](https://aurelien-clement.github.io/)

# Accès et utilisation 

## Vous pouvez accéder à l'application [sur ma page github](https://aurelien-clement.github.io/).

### 🟢 17/06/2024 - 15:50
Le problème de CORS origin est résolu, l'application est pleinement fonctionnelle.

### 🟠 17/06/2024 - 02:50 
Lorsque vous rechercherez un lieu, il est possible qu'aucune proposition ne charge et qu'un message d'erreur apparaisse : des requêtes sont bloquées par votre navigateur par mesure de sécurité (CORS-origin).

### 1. Solution express
> Actualisez la page et cliquez à nouveau dans le champ de recherche. le problème n'aura pas disparu, mais une localisation sera enregistrée dans vos favoris : vous pouvez cliquer dessus pour charger des données météo et utiliser l'interface.

### 2. Solution avancée (Flutter & Chrome)

> Si vous avez Flutter et Chrome, une méthode simple [trouvée sur Stack Overflow](https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code) permet de désactiver la protection CORS et d'accéder à toutes les fonctionnalités de l'application :
> 1. Allez dans `flutter\bin\cache` et supprimez le fichier `flutter_tools.stamp`
>
> 2. Allez dans `flutter\packages\flutter_tools\lib\src\web` et ouvrez `chrome.dart`
>
> 3. Recherchez  `'--disable-extensions'` et ajoutez `'--disable-web-security'`


_NB : Vous aurez le même problème de requête bloquée par le navigateur en téléchargeant la source et en l'exécutant depuis votre machine._


# Fonctionnalités et état  d'avancement

🟢 Trouver un lieu par recherche textuelle : **Terminé**

🟢 Récupérer les données météo : **Terminé**

🟢 Interface pour récupérer d'autres plages de dates : **Terminé**

🟢 Mettre en cache des données récupérées : **Terminé**

🟢 Afficher les données par jour / par heure : **Terminé**

🟢 Visualiser les données météo en graph :  **Terminé**

🔵 Stocker une liste de favoris : **À terminer** _(consultable seulement après rechargement de la page)_

🔵 Système métrique / impérial : **À terminer** _(implémenté mais pas intégré à l'UI)_

🟠 Tests fonctionnels : **minimaliste** _(manque de temps)_

🔴 Tests unitaires : **aucun** _(manque de temps)_

# Dépendances utilisées

### Services

- **`Open-meteo.com`** permet de récupérer un jeu complet de données météorologique pour des coordonnées données
- **`Google Maps Places`** propose 2 APIs que j'utilise pour que l'utilisateur sélectionne un lieu : 
  - `/Autocomplete` permet de récupérer une courte liste de suggestions pertinentes par rapport à la chaîne de caractères envoyée
  - `/Details` permet de récupérer des informations plus détaillées à partir de la suggestion choisie.

### Interface

- **`fl_charts`** pour l'affichage de courbes à partir d'un jeu de données
- **`Material Design 3`** pour avoir des widgets déjà fonctionnels et homogènes
- **`Syncfusion Flutter Datepicker`** parce que même Material Design a ses limites

### Utilitaires

- **`http`** pour appeler les différentes APIs
- **`uuid`** pour générer un token à envoyer à l'API Autocomplete
- **`intl`** pour le formattage des dates
- **`localizations`** pour la gestion des heures locales
- **`shared_preferences`** pour le stockage des favoris en local
- **`dotenv`** pour récupérer les variables d'environnement


# Organisation des fichiers

Un arbre vaut mieux qu'un long discours  🌱

```scss
📦 climatech/lib/
 ┃
 ┣ 📄 constants.dart
 ┣ 📄 main.dart
 ┃
 ┣ 📂 models/
 ┃ ┣ 📄 forecast_hour.dart          // Modèle données horaires
 ┃ ┣ 📄 forecast_date.dart          // Modèle pour les données quotidiennes
 ┃ ┣ 📄 forecast_location.dart      // Modèle pour le lieu sélectionné
 ┃ ┗ 📄 ui_states.dart              // Modèle pour l'état de l'interface
 ┃
 ┣ 📂 utils/
 ┃ ┣ 📄 date_operations.dart        // Opérations sur les dates
 ┃ ┣ 📄 screen_logger.dart          // Affichage messages d'erreur
 ┃ ┗ 📄 weathercode.dart            // Traduction codes WMO > texte ou picto
 ┃
 ┣ 📂 services/
 ┃ ┣ 📄 favorites_services.dart     // Gestion API open-meteo
 ┃ ┣ 📄 location_services.dart      // Gestion API Google Maps Places
 ┃ ┗ 📄 weather_services.dart       // Récupération des données météo
 ┃
 ┣ 📂 theme/
 ┃ ┗ 📄 app_theme.dart              // Copie du thème toujours accessible
 ┃
 ┣ 📂 screens/
 ┃ ┣ 📄 screen_home.dart            // Page unique de l'app
 ┃ ┗ 📄 screen_splash.dart          // Écran de chargement
 ┃
 ┗ 📂 widgets/
   ┣ 📄 navbar_search.dart          // Recherche, suggestions et sélection
   ┣ 📄 section_location.dart       // Haut de la page - lieu sélectionné
   ┣ 📄 section_forecasts.dart      // Bas de la page - Affichage prévisions
   ┃
   ┣ 📂 forecasts_tab_list/         // Onglet "Par heure" :
   ┃ ┣ 📄 forecasts_tab_list.dart   // Vue principale
   ┃ ┣ 📄 tab_list_day.dart         // Tuile 'journée' résumant les prévisions
   ┃ ┣ 📄 tab_list_day_content.dart // Contenu contrôlé par une tuile 'journée'
   ┃ ┗ 📄 tab_list_hour.dart        // Tuile 'heure' résumant les prévisions
   ┃
   ┗ 📂 forecasts_tab_chart/        // Onglet "Graphique" :
     ┣ 📄 forecasts_tab_chart.dart  // Vue principale
     ┣ 📄 tab_chart_graphs.dart     // Zone pour les graphiques
     ┗ 📄 tab_chart_options.dart    // Options du graph (dates, zoom, filtres)

 ```