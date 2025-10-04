# Guide des migrations Flyway

## Convention de nommage

Les fichiers de migration doivent suivre ce format :
- `V{version}__{description}.sql` pour les migrations versionnées
- `R__{description}.sql` pour les migrations répétables

Exemples :
- `V1__Initial_schema.sql`
- `V2__Add_user_email.sql`
- `V3__Add_index_on_username.sql`

## Numérotation des versions

- Utilisez des numéros incrémentaux : V1, V2, V3, etc.
- Pour des sous-versions : V1_1, V1_2, etc.
- **Ne modifiez JAMAIS une migration déjà appliquée en production**

## Créer une nouvelle migration

1. Créez un nouveau fichier dans `src/main/resources/db/migration/`
2. Nommez-le selon la convention (ex: `V2__Add_user_email.sql`)
3. Écrivez votre script SQL

Exemple de migration :
```sql
-- V2__Add_user_email.sql
ALTER TABLE users ADD COLUMN email VARCHAR(255);
CREATE INDEX idx_users_email ON users(email);
```

## État des migrations

Flyway crée automatiquement une table `flyway_schema_history` qui trace :
- Les migrations appliquées
- La date d'application
- Le checksum de chaque migration
- Le statut (success/failed)

## Commandes utiles

### Voir l'état des migrations (si Actuator est configuré)
```bash
curl http://localhost:8080/actuator/flyway
```

### En cas de problème

Si une migration échoue :
1. Corrigez le problème dans la base de données
2. Supprimez la ligne correspondante dans `flyway_schema_history`
3. Corrigez le fichier de migration
4. Relancez l'application

## Rollback

Flyway Community Edition ne supporte pas les rollbacks automatiques.
Pour un rollback :
1. Créez une nouvelle migration qui annule les changements
2. Exemple : si V5 ajoute une colonne, créez V6 qui la supprime

## Bonnes pratiques

1. ✅ Testez toujours vos migrations sur un environnement de dev d'abord
2. ✅ Faites des migrations petites et incrémentales
3. ✅ Utilisez des transactions (BEGIN/COMMIT) pour les opérations critiques
4. ✅ Ajoutez des commentaires pour expliquer les changements complexes
5. ❌ Ne modifiez jamais une migration déjà appliquée en production
6. ❌ N'utilisez pas `DROP TABLE` sans sauvegarder les données
7. ✅ Testez les performances sur de gros volumes de données

## Migration initiale

La migration `V1__Initial_schema.sql` a été créée automatiquement.
Si votre base de données existe déjà avec des données :

1. Flyway appliquera automatiquement `baseline-on-migrate=true`
2. Il marquera V1 comme appliquée sans l'exécuter
3. Seules les nouvelles migrations seront appliquées

## Vérification après installation

Au démarrage de l'application, vérifiez les logs :
```
Flyway Community Edition ... by Redgate
Database: jdbc:postgresql://localhost:5432/kholles_manager (PostgreSQL 15.x)
Successfully validated 1 migration
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
Migrating schema "public" to version "1 - Initial schema"
Successfully applied 1 migration to schema "public"
```

