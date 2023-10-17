#           _____                    _____                   _______                  _______               _____          
#          /\    \                  /\    \                 /::\    \                /::\    \             /\    \         
#         /::\    \                /::\    \               /::::\    \              /::::\    \           /::\    \        
#        /::::\    \              /::::\    \             /::::::\    \            /::::::\    \          \:::\    \       
#       /::::::\    \            /::::::\    \           /::::::::\    \          /::::::::\    \          \:::\    \      
#      /:::/\:::\    \          /:::/\:::\    \         /:::/~~\:::\    \        /:::/~~\:::\    \          \:::\    \     
#     /:::/  \:::\    \        /:::/__\:::\    \       /:::/    \:::\    \      /:::/    \:::\    \          \:::\    \    
#    /:::/    \:::\    \      /::::\   \:::\    \     /:::/    / \:::\    \    /:::/    / \:::\    \         /::::\    \   
#   /:::/    / \:::\    \    /::::::\   \:::\    \   /:::/____/   \:::\____\  /:::/____/   \:::\____\       /::::::\    \  
#  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\____\ |:::|    |     |:::|    ||:::|    |     |:::|    |     /:::/\:::\    \ 
# /:::/____/  ___\:::|    |/:::/  \:::\   \:::|    ||:::|____|     |:::|    ||:::|____|     |:::|    |    /:::/  \:::\____\
# \:::\    \ /\  /:::|____|\::/   |::::\  /:::|____| \:::\    \   /:::/    /  \:::\    \   /:::/    /    /:::/    \::/    /
#  \:::\    /::\ \::/    /  \/____|:::::\/:::/    /   \:::\    \ /:::/    /    \:::\    \ /:::/    /    /:::/    / \/____/ 
#   \:::\   \:::\ \/____/         |:::::::::/    /     \:::\    /:::/    /      \:::\    /:::/    /    /:::/    /          
#    \:::\   \:::\____\           |::|\::::/    /       \:::\__/:::/    /        \:::\__/:::/    /    /:::/    /           
#     \:::\  /:::/    /           |::| \::/____/         \::::::::/    /          \::::::::/    /     \::/    /            
#      \:::\/:::/    /            |::|  ~|                \::::::/    /            \::::::/    /       \/____/             
#       \::::::/    /             |::|   |                 \::::/    /              \::::/    /                            
#        \::::/    /              \::|   |                  \::/____/                \::/____/                             
#         \::/____/                \:|   |                   ~~                       ~~
# Ce script récupère et exporte des informations détaillées sur toutes les tâches planifiées d'une machine vers un fichier CSV.
# Il identifie également si une tâche planifiée est configurée pour exécuter un script spécifique (ps1, bat, cmd, vbs).


# Définit une fonction pour exporter des informations sur les tâches planifiées
function Export-ScheduledTasksInfo {
    # Déclare des paramètres avec des validations pour les entrées utilisateur
    param (
        # Délimiteur pour le fichier CSV, avec validation pour accepter uniquement certains caractères
        [ValidateSet(",", ";", "|")]
        [string]$delimiter = ";",

        # Répertoire de sortie pour le fichier CSV, avec validation pour vérifier l'existence du chemin
        [ValidateScript({
            if (Test-Path $_) { $true }
            else { throw "Le répertoire spécifié n'existe pas." }
        })]
        [string]$outputDirectory = $HOME
    )

    # Bloc try pour gérer les erreurs de manière élégante
    try {
        # Obtient le nom de la machine actuelle
        $computerName = [System.Environment]::MachineName

        # Récupère toutes les tâches planifiées et les traite une par une
        $tasks = Get-ScheduledTask | ForEach-Object {
            # Récupère des informations détaillées sur la tâche planifiée
            $info = Get-ScheduledTaskInfo $_

            # Récupère les actions associées à la tâche et détermine si elle exécute un script
            $actions = $_.Actions | ForEach-Object { $_.Execute }
            $isScript = $actions -join ' ' -match '\.(ps1|bat|cmd|vbs)$'

            # Crée et retourne un objet personnalisé avec les informations collectées
            [PSCustomObject]@{
                'Machine' = $computerName
                'Nom de la Tache' = $_.TaskName
                'Chemin de la Tache' = $_.TaskPath
                'Etat' = $_.State
                'Action' = $actions -join ', '
                'Prochaine Execution' = $info.NextRunTime
                'Derniere Execution' = $info.LastRunTime
                'Est un script' = $isScript
            }
        }

        # Construit le chemin complet du fichier CSV de sortie
        $filePath = Join-Path -Path $outputDirectory -ChildPath ("tachesPlanifiees-$computerName.csv")

        # Exporte les objets de tâche dans un fichier CSV avec le délimiteur spécifié
        $tasks | Export-Csv -Path $filePath -NoTypeInformation -Delimiter $delimiter

        # Affiche des informations sur le nombre de tâches et le chemin du fichier CSV
        Write-Host "Il y a $($tasks.Count) taches planifiees sur la machine $($computerName)."
        Write-Host "Les taches sont enregistrees dans le fichier : $filePath"
    }
    # Bloc catch pour gérer et afficher les erreurs
    catch {
        Write-Host "Une erreur est survenue : $_. Pour obtenir de l'aide, veuillez fournir cette information à votre administrateur système ou consulter la documentation."
    }
}

# Appelle la fonction avec des paramètres spécifiques
Export-ScheduledTasksInfo -delimiter ";" -outputDirectory "$HOME"
