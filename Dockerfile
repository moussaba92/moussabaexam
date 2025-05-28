# Utilise une image officielle Node.js légère
FROM node:18-alpine

# Dossier de travail dans le conteneur
WORKDIR /app

# Copie les fichiers du projet
COPY . .

# Installe les dépendances
RUN npm install

# Expose le port (modifie-le si ton app utilise un autre)
EXPOSE 3000

# Démarre l'application
CMD ["npm", "start"]
