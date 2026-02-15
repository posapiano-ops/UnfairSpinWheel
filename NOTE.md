# Docker Setup per Vue.js

Setup completo Docker per progetti Vue.js con configurazioni separate per sviluppo e produzione.

## 📋 Prerequisiti

- Docker installato
- Docker Compose installato

## 🚀 Avvio Rapido

### Modalità Sviluppo (con hot reload)

```bash
# Avvia il container di sviluppo
docker-compose up vue-dev

# Oppure in background
docker-compose up -d vue-dev
```

L'applicazione sarà disponibile su: http://localhost:5173

### Modalità Produzione

```bash
# Build e avvio del container di produzione
docker-compose --profile production up vue-prod

# Oppure in background
docker-compose --profile production up -d vue-prod
```

L'applicazione sarà disponibile su: http://localhost:8080

## 🛠️ Comandi Utili

### Sviluppo

```bash
# Fermare i container
docker-compose down

# Ricostruire l'immagine
docker-compose build vue-dev

# Vedere i log
docker-compose logs -f vue-dev

# Eseguire comandi npm nel container
docker-compose exec vue-dev npm install <package>
docker-compose exec vue-dev npm run lint
```

### Produzione

```bash
# Build dell'immagine di produzione
docker build -t vue-app:prod --target production .

# Run manuale
docker run -d -p 8080:80 --name vue-app vue-app:prod

# Fermare e rimuovere
docker stop vue-app && docker rm vue-app
```

## 📁 Struttura File

```
.
├── Dockerfile              # Dockerfile multi-stage
├── docker-compose.yml      # Orchestrazione dei container
├── nginx.conf              # Configurazione Nginx per produzione
├── .dockerignore           # File da escludere dalla build
├── package.json            # Dipendenze del progetto
├── vite.config.js          # Configurazione Vite
└── src/                    # Codice sorgente Vue.js
```

## ⚙️ Configurazione Vite

Per far funzionare correttamente il dev server con Docker, assicurati che il tuo `vite.config.js` contenga:

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    watch: {
      usePolling: true
    }
  }
})
```

## 🔧 Personalizzazioni

### Cambiare le porte

Modifica il file `docker-compose.yml`:

```yaml
ports:
  - "3000:5173"  # Cambia 3000 con la porta desiderata
```

### Variabili d'ambiente

Crea un file `.env` nella root del progetto:

```
VITE_API_URL=https://api.esempio.it
VITE_APP_TITLE=La Mia App
```

Poi modifica `docker-compose.yml`:

```yaml
env_file:
  - .env
```

### Nginx personalizzato

Modifica il file `nginx.conf` per aggiungere:
- Proxy reverse verso API
- Headers di sicurezza aggiuntivi
- Rate limiting
- SSL/TLS

## 🐛 Troubleshooting

### Hot reload non funziona

Assicurati che `CHOKIDAR_USEPOLLING=true` sia impostato nel docker-compose.yml.

### Permessi sui file

Se hai problemi con i permessi, aggiungi al Dockerfile:

```dockerfile
RUN chown -R node:node /app
USER node
```

### Build lenta

Usa la cache di Docker:

```bash
docker-compose build --parallel
```

## 📦 Ottimizzazioni Produzione

Il Dockerfile di produzione include:
- ✅ Build multi-stage (riduce dimensione immagine)
- ✅ Compressione Gzip
- ✅ Cache degli asset statici
- ✅ Routing per Vue Router (history mode)
- ✅ Headers di sicurezza

## 🔒 Sicurezza

In produzione, considera di:
- Usare variabili d'ambiente per dati sensibili
- Implementare HTTPS con certificati SSL
- Configurare rate limiting in Nginx
- Aggiornare regolarmente le immagini base
