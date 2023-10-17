# Exportation des Informations des Tâches Planifiées

## Description

Ce script PowerShell nommé ```getScheduledTasks```
 est conçu pour exporter des informations détaillées sur toutes les tâches planifiées d'une machine vers un fichier CSV. Il détermine également si une tâche spécifique est configurée pour exécuter un type de script particulier, comme ps1, bat, cmd ou vbs.

## Fonctionnalités

- Récupère toutes les tâches planifiées sur une machine.
- Exporte les détails des tâches, y compris le nom, le chemin, l'état, l'action, la prochaine exécution et la dernière exécution dans un fichier CSV.
- Identifie les tâches qui sont configurées pour exécuter des scripts.

## Comment utiliser

Le script peut être exécuté de deux manières :

### 1. Appel Direct

Vous pouvez appeler le script directement en utilisant le nom du fichier script :

```powershell
./scheduledTasks.ps1
```

### 2. Utilisation de la Fonction

Importez le script et appelez la fonction avec des paramètres spécifiques, si nécessaire :

```. .\scheduledTasks.ps1
Export-ScheduledTasksInfo -delimiter ";" -outputDirectory "$HOME"

```

2. **Résultats :**  
   Le script générera un fichier CSV contenant les détails des tâches planifiées. Il affichera également le nombre total de tâches récupérées et le chemin du fichier CSV généré.

## Support et Contribution

Pour toute question, problème ou suggestion, n'hésitez pas à ouvrir une issue dans ce dépôt GitHub.

## Licence

Ce script est disponible sous licence MIT. Vous êtes libre de l'utiliser, de le modifier et de le distribuer en respectant les termes de la licence.
