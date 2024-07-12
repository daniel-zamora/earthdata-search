import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { ViteEjsPlugin } from 'vite-plugin-ejs'
import { nodePolyfills } from 'vite-plugin-node-polyfills'
import { resolve } from 'path'

import availablePortals from './portals/index'

import { getApplicationConfig } from './sharedUtils/config'

const {
  analytics,
  defaultPortal,
  env,
  feedbackApp
} = getApplicationConfig()

const { [defaultPortal]: portalConfig } = availablePortals
const { ui } = portalConfig
const { showTophat } = ui

export default defineConfig({
  root: 'static/src',
  server: {
    host: true,
    port: 8080
  },
  plugins: [
    ViteEjsPlugin({
      env,
      environment: process.env.NODE_ENV,
      feedbackApp,
      gaPropertyId: analytics.localIdentifier.propertyId,
      gtmPropertyId: analytics.gtmPropertyId,
      includeDevGoogleAnalytics: analytics.localIdentifier.enabled,
      showTophat
    }),
    react(),
    nodePolyfills()
  ],
  css: {
    devSourcemap: true
  },
  resolve: {
    alias: {
      '~bootstrap': resolve(__dirname, 'node_modules/bootstrap'),
      '~Fonts': resolve(__dirname, 'static/src/assets/fonts'),
      '~Images': resolve(__dirname, 'static/src/assets/images')
    }
  }
})
