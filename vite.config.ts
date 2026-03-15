/// <reference types="vitest" />
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  base: './',
  plugins: [react()],
  server: {
    proxy: {
      '/mft-auth': {
        target: 'https://integration-myforterro-core.fcs-dev.eks.forterro.com',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/mft-auth/, ''),
        secure: true,
        // Strip WWW-Authenticate so the browser doesn't show its native auth dialog on 401
        configure: (proxy) => {
          proxy.on('proxyRes', (proxyRes) => {
            delete proxyRes.headers['www-authenticate']
          })
        },
      },
      '/mft-api': {
        target: 'https://integration-myforterro-api.fcs-dev.eks.forterro.com',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/mft-api/, ''),
        secure: true,
        configure: (proxy) => {
          proxy.on('proxyReq', (proxyReq, req) => {
            console.log(`[Proxy] ${req.method} ${req.url} -> ${proxyReq.protocol}//${proxyReq.host}${proxyReq.path}`)
            console.log('[Proxy] Authorization:', proxyReq.getHeader('authorization')?.toString().slice(0, 40) + '...')
          })
          proxy.on('proxyRes', (proxyRes, req) => {
            console.log(`[Proxy] Response: ${proxyRes.statusCode} for ${req.url}`)
            delete proxyRes.headers['www-authenticate']
          })
        },
      },
    },
  },
  build: {
    modulePreload: false,
    target: 'esnext',
    rollupOptions: {
      output: {
        format: 'iife',
      },
    },
  },
  test: {
    globals: true,
    environment: 'happy-dom',
    setupFiles: './src/test-setup.ts',
    css: { modules: { classNameStrategy: 'non-scoped' } },
  },
})
