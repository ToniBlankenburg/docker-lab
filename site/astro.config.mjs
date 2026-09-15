// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// GitHub Pages Deploy-URL. Vor dem ersten Deploy in eurem Fork anpassen
// (siehe README.md, Abschnitt "Deploy").
const SITE = process.env.SITE_URL ?? 'https://example.github.io';
const BASE = process.env.SITE_BASE ?? '/';

export default defineConfig({
  site: SITE,
  base: BASE,
  integrations: [
    starlight({
      title: 'Cloud-Schulung',
      defaultLocale: 'de',
      locales: {
        de: { label: 'Deutsch', lang: 'de' },
        en: { label: 'English', lang: 'en' },
      },
      sidebar: [
        {
          label: 'Prolog',
          translations: { en: 'Prologue' },
          items: [{ autogenerate: { directory: 'prolog' } }],
        },
        {
          label: 'Kern',
          translations: { en: 'Core' },
          items: [{ autogenerate: { directory: 'kern' } }],
        },
        {
          label: 'Vertiefung',
          translations: { en: 'Advanced' },
          items: [{ autogenerate: { directory: 'vertiefung' } }],
        },
      ],
    }),
  ],
});
