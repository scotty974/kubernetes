NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | cmd.exe /c jq -r '.tunnels[0].public_url')
echo $NGROK_URL

# Définis les variables pour l'authentification et l'URL du dépôt GitHub
GITHUB_TOKEN=$(cmd.exe /c echo %Github_token%)

REPO_OWNER="scotty974"
REPO_NAME="kubernetes"

# Créer le webhook dans GitHub
curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{
           "name": "web",
           "config": {
             "url": "'"$NGROK_URL"'",
             "content_type": "json",
             "insecure_ssl": "1"
           },
           "events": ["push"],
           "active": true
         }' \
     "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/hooks"
