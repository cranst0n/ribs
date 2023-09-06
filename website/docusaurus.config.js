// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

const organizationName = "cranst0n";
const projectName = "ribs";

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Ribs',
  favicon: 'img/favicon.ico',

  url: `https://${organizationName}.github.io`,
  baseUrl: `/${projectName}/`,
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "throw",
  trailingSlash: false,

  organizationName,
  projectName,

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  plugins: ['docusaurus-plugin-sass'],

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/cranst0n/ribs/edit/main/website/',
        },
        theme: {
          customCss: require.resolve('./src/scss/custom.scss'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/logo.jpg',
      colorMode: {
        defaultMode: 'light',
      },
      navbar: {
        title: 'Ribs',
        logo: {
          alt: 'Ribs Logo',
          src: 'img/logo.png',
        },
        items: [
          {
            to: "docs/intro",
            activeBasePath: "docs",
            label: "Docs",
            position: "right",
          },
          // {
          //   type: "localeDropdown",
          //   position: "right",
          // },
          {
            href: `https://github.com/${organizationName}/${projectName}`,
            label: "GitHub",
            position: "right",
          },
        ],
      },
      prism: {
        defaultLanguage: "dart",
        additionalLanguages: ["dart", "yaml"],
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
      algolia: {
        appId: 'YWCHX7514Y',
        apiKey: '0b2ec772b110e2d156835cbd355a8d01',
        indexName: 'ribs',
      },
    }),
};

module.exports = config;
