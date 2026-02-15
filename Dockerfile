# Dockerfile multi-stage per Vue.js

# Stage 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copia i file di dipendenze
COPY package*.json ./

# Installa le dipendenze
RUN npm ci

# Copia il resto del codice
COPY . .

# Build dell'applicazione per produzione
RUN npm run build

# Stage 2: Production (con Nginx)
FROM nginx:alpine AS production

# Copia i file buildati
COPY --from=build /app/dist /usr/share/nginx/html

# Copia configurazione Nginx personalizzata (opzionale)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# Stage 3: Development
FROM node:20-alpine AS development

WORKDIR /app

# Copia i file di dipendenze
COPY package*.json ./

# Installa le dipendenze (incluse quelle di dev)
RUN npm install

# Esponi la porta del dev server
EXPOSE 5173

# Comando per avviare il dev server
CMD ["npm", "run", "dev"]
