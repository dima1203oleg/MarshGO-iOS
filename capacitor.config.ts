import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'ua.marshgo.app',
  appName: 'MARSHGO',
  webDir: 'web/dist',
  ios: { contentInset: 'never', preferredContentMode: 'mobile' },
  plugins: {
    StatusBar: { overlaysWebView: true, style: 'DARK' },
    SplashScreen: {
      launchShowDuration: 15_000,
      launchAutoHide: true,
      backgroundColor: '#081B35',
      showSpinner: false,
    },
  },
};

export default config;
