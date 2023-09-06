import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';

import styles from './index.module.css';

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx("banner", styles.heroBanner)}>
      <div className="container">
        <h1 className="banner__logo">{siteConfig.title}</h1>

        <h1 className="banner__logo">
          <img src="img/logo.png" alt="Riverpod" />
        </h1>

        <h3 className="banner__headline">
          A Collection of Functional Programming Libraries for Dart
        </h3>

        <div>
          <Link
            className="button button--primary button--lg"
            to="/docs/intro">
            Get Started
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title}`}
      description="Functional programming libraries for Dart.">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
