![Logo Khôlle'n'dar](src/main/resources/static/images/logo.svg)
# Khôlle'n'dar

## 📚 Présentation

Khôlle'n'dar est une application web dédiée à la gestion et l'organisation des sessions de khôlles en milieu universitaire. L'objectif principal est d'optimiser l'affectation des étudiants aux différentes sessions de khôlles, permettant ainsi une meilleure organisation pour les enseignants et les étudiants. La plateforme centralise toutes les informations relatives aux khôlles, facilitant le suivi et la planification.

## ✨ Fonctionnalités

- **Gestion des sessions de khôlles**
  - Création de sessions avec plusieurs créneaux horaires
  - Visualisation des sessions passées et à venir

- **Système d'affectation**
  - Attribution des créneaux aux étudiants
  - Vue d'ensemble des affectations

- **Suivi et administration**
  - Gestion centralisée des créneaux
  - Historique des sessions

## 🛠️ Technologies utilisées

- **Backend**
  - Java 17+
  - Spring Boot 3.x
  - JPA / Hibernate
  - PostgreSQL

- **Frontend**
  - JTE (Java Template Engine)
  - Tailwind CSS
  - JavaScript

## 🚀 Installation et Configuration

### Prérequis
- Java 17 ou supérieur
- PostgreSQL
- Gradle

### Configuration de la base de données

1. Copiez le fichier de configuration exemple :
   ```bash
   cp src/main/resources/application.properties.example src/main/resources/application.properties
   ```

2. Modifiez `src/main/resources/application.properties` avec vos propres valeurs :
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/votre_base
   spring.datasource.username=votre_utilisateur
   spring.datasource.password=votre_mot_de_passe
   admin.password=votre_mot_de_passe_admin
   ```

   **⚠️ Important** : Ne commitez JAMAIS le fichier `application.properties` avec vos credentials réels. Ce fichier est ignoré par Git.

### Lancement de l'application

```bash
./gradlew bootRun
```

L'application sera accessible sur `http://localhost:8080`

## 📝 Licence

Ce projet est sous licence [GNU GPL v3](LICENSE).

## 👥 Auteur

- [Tom BUTIN](https://redstom.fr)