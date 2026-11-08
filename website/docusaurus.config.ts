import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Wayshell',
  tagline: 'A wayland shell built for you',
  favicon: 'favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://github.com/mora1ss/wayshell',
  baseUrl: '/',

  organizationName: 'mora1ss',
  projectName: 'wayshell',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  headTags: [
    {
      tagName: 'link',
      attributes: {rel: 'icon', href: '/favicon-48.png', type: 'image/png', sizes: '48x48'},
    },
    {
      tagName: 'link',
      attributes: {rel: 'icon', href: '/favicon-192.png', type: 'image/png', sizes: '192x192'},
    },
    {
      tagName: 'link',
      attributes: {rel: 'apple-touch-icon', href: '/apple-touch-icon.png'},
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'preload',
        href: '/img/logo-dark.svg',
        as: 'image',
        type: 'image/svg+xml',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'preload',
        href: '/img/logo-light.svg',
        as: 'image',
        type: 'image/svg+xml',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'preload',
        href: '/img/logo.svg',
        as: 'image',
        type: 'image/svg+xml',
      },
    },
  ],

  themes: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        docsRouteBasePath: '/',
        docsDir: '../docs',
        indexBlog: false,
        searchBarShortcutHint: false,
        highlightSearchTermsOnTargetPage: true,
        explicitSearchResultPath: true,
      },
    ],
  ],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',
          path: '../docs',
          editUrl: 'https://github.com/mora1ss/wayshell/edit/main/docs/',
        },
        blog: false,
        theme: {
          customCss: ['./src/css/custom.css', './src/css/docs.css'],
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/social-card.jpg',
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: false,
    },
    navbar: {
      title: 'Wayshell',
      logo: {
        alt: 'Wayshell Logo',
        src: 'img/logo-light.svg',
        srcDark: 'img/logo-dark.svg',
        width: 32,
        height: 32,
      },
      items: [
        {
          to: '/overview',
          label: 'Documentation',
          position: 'left',
        },
        {
          href: 'https://github.com/mora1ss/wayshell/blob/main/CHANGELOG.md',
          label: 'Changelog',
          position: 'left',
          className: 'navbar-changelog-link',
        },
        {
          type: 'search',
          position: 'right',
        },
        {
          href: 'https://github.com/mora1ss/wayshell',
          label: 'GitHub',
          position: 'right',
          className: 'navbar-github-link',
          'aria-label': 'GitHub repository',
        },
      ],
    },
    footer: {
      style: 'dark',
      logo: {
        alt: 'Wayshell Logo',
        src: 'img/logo-light.svg',
        srcDark: 'img/logo-dark.svg',
        width: 44,
        height: 44,
      },
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Overview',
              to: '/overview',
            },
            {
              label: 'Installation',
              to: '/installation',
            },
            {
              label: 'Variables',
              to: '/configure',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/mora1ss/wayshell',
            },
          ],
        },
      ],
      copyright: `A desktop shell built for YOU. Copyright © ${new Date().getFullYear()} Wayshell.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['bash', 'ini', 'json', 'lua', 'nix'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
