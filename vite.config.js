import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  
  // Configurazione per Docker
  server: {
    host: '0.0.0.0', // Necessario per esporre il server fuori dal container
    port: 5173,
    strictPort: true,
    watch: {
      usePolling: true, // Necessario per hot reload in Docker
    },
    hmr: {
      clientPort: 5173, // Porta per Hot Module Replacement
    }
  },
  
  // Alias per import più puliti
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  
  // Configurazione build
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false,
    minify: 'terser',
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue', 'vue-router'],
        },
      },
    },
  },
})
