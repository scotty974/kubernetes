#!/bin/bash
 
# Récupérer l'URL publique de Ngrok
# NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
 
# Modifie l'URL pour le point de terminaison du webhook
WEBHOOK_URL="https://1b30-37-70-218-118.ngrok-free.app/"
 
# Configuration du webhook GitHub
REPO="scotty974/kubernetes"  # Remplacez par votre nom d'utilisateur et dépôt
TOKEN=""
 
# Supprimer le webhook existant (optionnel)
curl -X DELETE -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/$REPO/hooks"

# Vérifier la suppression du webhook
if [ $? -ne 0 ]; then
    echo "Échec de la suppression du webhook"
    exit 1
fi

# Créer le webhook GitHub
curl -X POST -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/hooks" \
  -d "{
    \"config\": {
      \"url\": \"$WEBHOOK_URL\",
      \"content_type\": \"json\"
    },
    \"events\": [
      \"push\"
    ],
    \"active\": true
  }"

# Vérifier la création du webhook
if [ $? -ne 0 ]; then
    echo "Échec de la création du webhook"
    exit 1
fi

echo "Webhook configuré avec succès à l'adresse : $WEBHOOK_URL"

# Maintenir la console ouverte
sleep 50