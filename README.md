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
  - Java 21+
  - Spring Boot 3.x
  - JPA / Hibernate
  - PostgreSQL
  - Flyway (migrations de base de données)

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

Modifiez `src/main/resources/application.properties` avec vos propres valeurs :
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/votre_base
spring.datasource.username=votre_utilisateur
spring.datasource.password=votre_mot_de_passe
admin.password=votre_mot_de_passe_admin
```

**⚠️ Important** : Ne commitez JAMAIS le fichier `application.properties` avec vos credentials réels. Ce fichier est ignoré par Git.

Pour éviter cela, vous pouvez également utiliser les variables d'environnement :
```dotenv
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/votre_base
SPRING_DATASOURCE_USERNAME=votre_utilisateur
SPRING_DATASOURCE_PASSWORD=votre_mot_de_passe

ADMIN_PASSWORD=votre_mot_de_passe_admin
```

### Migrations de base de données

L'application utilise **Flyway** pour gérer les migrations de base de données de manière versionnée et contrôlée.

- Les migrations sont situées dans `src/main/resources/db/migration/`
- Au premier démarrage, Flyway créera automatiquement le schéma de base de données
- Pour plus d'informations sur la création de nouvelles migrations, consultez `src/main/resources/db/migration/README.md`

**Note** : Si vous avez déjà une base de données existante, Flyway utilisera `baseline-on-migrate=true` pour marquer le schéma actuel comme version de base sans le modifier.

### Lancement de l'application

```bash
./gradlew bootRun
```

L'application sera accessible sur `http://localhost:8080`

## 📝 Licence

Ce projet est sous licence [GNU GPL v3](LICENSE).

## 👥 Auteur

- [Tom BUTIN](https://redstom.fr)